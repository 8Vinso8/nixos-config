pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../components"

Item {
    id: root

    property bool active: false
    property var clipboardItems: []
    property string selectedFullText: ""
    property string selectedPartialText: ""
    property var activePreviewItem: null

    readonly property string cacheDir: `${Quickshell.env("XDG_RUNTIME_DIR") || "/run/user/1000"}/quickshell/cliphist`

    Process {
        id: listProc
        stdout: StdioCollector {
            onStreamFinished: root.parseCliphist(text)
        }
    }

    Process {
        id: textDecodeProc
        stdout: StdioCollector {
            onStreamFinished: root.selectedFullText = text
        }
    }

    Process {
        id: deleteProc
        onExited: root.reloadHistory()
    }

    function reloadHistory() {
        // Сначала декодируем новые изображения в кэш, затем отдаем список — чтобы все PNG уже были на диске к моменту отрисовки делегатов
        listProc.exec([
            "sh", "-c",
            `mkdir -p "${root.cacheDir}" && cliphist list | head -n 150 | grep -a '\\[\\[ binary data' | head -n 40 | awk '{print $1}' | while read -r id; do out="${root.cacheDir}/$id.png"; [ -f "$out" ] || (cliphist decode "$id" > "$out.tmp" && mv "$out.tmp" "$out"); done && cliphist list | head -n 150`
        ]);
    }

    function parseCliphist(rawText: string) {
        if (!rawText || rawText.length === 0) {
            root.clipboardItems = [];
            root.activePreviewItem = null;
            root.selectedFullText = "";
            return;
        }

        const lines = rawText.split("\n");
        const items = [];
        const maxItems = 150;

        for (let i = 0; i < lines.length && items.length < maxItems; i++) {
            const line = lines[i];
            if (!line)
                continue;

            const tabIdx = line.indexOf("\t");
            if (tabIdx === -1)
                continue;

            const id = line.substring(0, tabIdx).trim();
            const content = line.substring(tabIdx + 1).trim();
            if (content.length === 0)
                continue;

            const isBinary = content.startsWith("[[ binary data");
            let title = content;
            let subtitle = "";
            let badge = "";
            let icon = "󰅍";
            let color = Theme.mauve;
            let imagePath = "";

            if (isBinary) {
                imagePath = `file://${root.cacheDir}/${id}.png`;
                const match = content.match(/binary data\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/);
                if (match) {
                    badge = `${match[3].toUpperCase()} ${match[1]} ${match[2]}`;
                    subtitle = match[4] ?? "";
                } else {
                    badge = "Image";
                    subtitle = "Бинарные данные";
                }
                title = "Изображение в буфере";
                icon = "󰋩";
                color = Theme.blue;
            } else {
                title = content.replace(/[\r\n\t]+/g, " ");
                subtitle = content.length > 50 ? `${content.length} симв.` : "";
                icon = "󰅍";
            }

            items.push({
                id: id,
                rawLine: line,
                title: title,
                subtitle: subtitle,
                badge: badge,
                icon: icon,
                color: color,
                imagePath: imagePath,
                isBinary: isBinary,
                searchBlob: content.toLowerCase()
            });
        }

        root.clipboardItems = items;
        previewDebounce.restart();
    }

    Timer {
        id: previewDebounce
        interval: 80
        onTriggered: root.commitPreview()
    }

    function commitPreview() {
        root.selectedPartialText = "";
        if (!loader.item)
            return;
        const overlay = loader.item;
        const idx = overlay.listView.currentIndex;
        const items = overlay.filteredItems;
        const item = (idx >= 0 && idx < items.length) ? items[idx] : null;

        root.activePreviewItem = item;
        if (!item) {
            root.selectedFullText = "";
            return;
        }

        root.selectedFullText = item.title;
        if (!item.isBinary) {
            textDecodeProc.exec(["cliphist", "decode", item.id]);
        }
    }

    function closeMenu() {
        if (loader.item)
            loader.item.close();
        else
            root.active = false;
    }

    function copyText(text: string) {
        root.closeMenu();
        Quickshell.execDetached(["wl-copy", "--", text.replace(/[\u2028\u2029]/g, "\n")]);
    }

    function copyItem(id: string) {
        root.closeMenu();
        Quickshell.execDetached(["sh", "-c", "cliphist decode \"$1\" | wl-copy", "--", id]);
    }

    function deleteItem(item: var) {
        if (!item)
            return;

        // 1. Мгновенно убираем элемент из UI, сохраняя позицию курсора
        const savedIdx = loader.item ? loader.item.listView.currentIndex : 0;
        root.clipboardItems = root.clipboardItems.filter(x => x.id !== item.id);

        if (loader.item) {
            const count = loader.item.filteredItems.length;
            loader.item.listView.currentIndex = Math.min(savedIdx, Math.max(0, count - 1));
            root.commitPreview();
        }

        // 2. Удаляем из базы cliphist и стираем кэш PNG
        deleteProc.exec([
            "sh", "-c",
            "printf '%s\\n' \"$1\" | cliphist delete && rm -f \"$2\"",
            "--",
            item.rawLine,
            `${root.cacheDir}/${item.id}.png`
        ]);
    }

    Component.onCompleted: reloadHistory()

    IpcHandler {
        target: "clipboard"

        function open(): void {
            root.reloadHistory();
            if (loader.item)
                loader.item.open();
            else
                root.active = true;
        }

        function close(): void {
            root.closeMenu();
        }

        function toggle(): void {
            if (root.active && loader.item?.shown) {
                root.closeMenu();
            } else {
                open();
            }
        }
    }

    LazyLoader {
        id: loader
        active: root.active

        MenuOverlay {
            id: clipOverlay
            searchPlaceholder: "Поиск в буфере обмена..."
            cardWidth: 960
            cardHeight: 540
            sidePanelWidth: 500

            Component.onCompleted: root.commitPreview()
            onClosedAndHidden: root.active = false

            readonly property var filteredItems: {
                const q = clipOverlay.searchText.trim().toLowerCase();
                if (q.length === 0)
                    return root.clipboardItems;
                return root.clipboardItems.filter(item => item.searchBlob.includes(q));
            }

            Connections {
                target: clipOverlay.listView
                function onCurrentIndexChanged() {
                    previewDebounce.restart();
                }
            }

            function activateIndex(idx: int) {
                if (root.selectedPartialText.length > 0) {
                    root.copyText(root.selectedPartialText);
                } else if (idx >= 0 && idx < filteredItems.length) {
                    root.copyItem(filteredItems[idx].id);
                }
            }

            onActivated: idx => activateIndex(idx)
            onDeleteRequested: idx => {
                if (idx >= 0 && idx < filteredItems.length) {
                    root.deleteItem(filteredItems[idx]);
                }
            }
            onCopyRequested: {
                if (root.selectedPartialText.length > 0) {
                    root.copyText(root.selectedPartialText);
                } else if (root.activePreviewItem) {
                    root.copyItem(root.activePreviewItem.id);
                }
            }

            onSearchTextChanged: {
                listView.currentIndex = 0;
                listView.positionViewAtBeginning();
                previewDebounce.stop();
                root.commitPreview();
            }

            listView.model: clipOverlay.filteredItems

            listView.delegate: MenuItemDelegate {
                required property int index
                required property var modelData

                selectOnClick: true
                isCurrent: clipOverlay.listView.currentIndex === index
                title: modelData.title ?? ""
                subtitle: modelData.subtitle ?? ""
                fallbackIcon: modelData.icon ?? "󰅍"
                iconColor: modelData.color ?? Theme.mauve
                iconSource: modelData.imagePath ?? ""
                badge: modelData.badge ?? ""

                onSelected: {
                    clipOverlay.listView.currentIndex = index;
                    previewDebounce.stop();
                    root.commitPreview();
                }
                onActivated: clipOverlay.activateIndex(index)
            }

            sidePanel: Component {
                Rectangle {
                    id: previewCard
                    radius: 12
                    color: Theme.surface
                    border.color: Theme.border
                    border.width: 1
                    clip: true

                    readonly property var currentItem: root.activePreviewItem

                    Column {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10

                        Item {
                            width: parent.width
                            height: 28

                            Row {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 8

                                BarText {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: previewCard.currentItem ? (previewCard.currentItem.isBinary ? "󰋩" : "󰅍") : "󰅍"
                                    font.pixelSize: 16
                                    color: previewCard.currentItem ? previewCard.currentItem.color : Theme.mauve
                                }

                                BarText {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: previewCard.currentItem ? (previewCard.currentItem.isBinary ? "Изображение" : "Текст") : "Предпросмотр"
                                    font.bold: true
                                    font.pixelSize: 12
                                    color: Theme.text
                                }

                                BarText {
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: previewCard.currentItem !== null
                                    text: previewCard.currentItem ? (previewCard.currentItem.badge ? (previewCard.currentItem.badge + (previewCard.currentItem.subtitle ? `  •  ${previewCard.currentItem.subtitle}` : "")) : previewCard.currentItem.subtitle) : ""
                                    font.pixelSize: 11
                                    color: Theme.subtext
                                }
                            }

                            Rectangle {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                visible: previewCard.currentItem !== null
                                width: copyBtnContent.implicitWidth + 14
                                height: 26
                                radius: 6
                                color: copyBtnHover.hovered ? Theme.mauve : Theme.surface
                                border.color: Theme.mauve
                                border.width: 1

                                HoverHandler {
                                    id: copyBtnHover
                                    cursorShape: Qt.PointingHandCursor
                                }

                                TapHandler {
                                    onTapped: {
                                        if (previewFullText.selectedText.length > 0)
                                            root.copyText(previewFullText.selectedText);
                                        else if (previewCard.currentItem)
                                            root.copyItem(previewCard.currentItem.id);
                                    }
                                }

                                Row {
                                    id: copyBtnContent
                                    anchors.centerIn: parent
                                    spacing: 5

                                    BarText {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "󰆏"
                                        font.pixelSize: 11
                                        color: copyBtnHover.hovered ? Theme.base : Theme.mauve
                                    }

                                    BarText {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: previewFullText.selectedText.length > 0 ? "Копировать выделенное" : "Копировать"
                                        font.bold: true
                                        font.pixelSize: 11
                                        color: copyBtnHover.hovered ? Theme.base : Theme.text
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: Theme.border
                        }

                        Item {
                            width: parent.width
                            height: parent.height - 40

                            BarText {
                                anchors.centerIn: parent
                                visible: !previewCard.currentItem
                                text: "Ничего не выбрано"
                                color: Theme.subtext
                                font.pixelSize: 12
                            }

                            Item {
                                anchors.fill: parent
                                visible: previewCard.currentItem !== null && previewCard.currentItem.isBinary

                                BarText {
                                    anchors.centerIn: parent
                                    visible: previewImage.status !== Image.Ready
                                    text: previewImage.status === Image.Loading ? "Загрузка..." : "󰋩"
                                    font.pixelSize: 32
                                    color: Theme.subtext
                                }

                                Image {
                                    id: previewImage
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    source: (previewCard.currentItem && previewCard.currentItem.isBinary && previewCard.currentItem.imagePath) ? previewCard.currentItem.imagePath : ""
                                    smooth: true
                                    asynchronous: true
                                    cache: false
                                }
                            }

                            Flickable {
                                id: textFlickable
                                anchors.fill: parent
                                visible: previewCard.currentItem !== null && !previewCard.currentItem.isBinary
                                interactive: false
                                contentWidth: width
                                contentHeight: previewFullText.implicitHeight
                                clip: true
                                boundsBehavior: Flickable.StopAtBounds

                                WheelHandler {
                                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                    onWheel: event => {
                                        const maxScroll = Math.max(0, textFlickable.contentHeight - textFlickable.height);
                                        textFlickable.contentY = Math.max(0, Math.min(maxScroll, textFlickable.contentY - event.angleDelta.y * 1.5));
                                    }
                                }

                                TextEdit {
                                    id: previewFullText
                                    width: textFlickable.width
                                    text: root.selectedFullText
                                    wrapMode: TextEdit.Wrap
                                    readOnly: true
                                    selectByMouse: true
                                    persistentSelection: true
                                    activeFocusOnPress: true
                                    cursorVisible: false
                                    selectionColor: Theme.mauve
                                    selectedTextColor: Theme.base
                                    color: Theme.text
                                    font.family: Theme.fontFamily
                                    font.pixelSize: 11
                                    font.bold: false

                                    onTextChanged: {
                                        textFlickable.contentY = 0;
                                        deselect();
                                    }
                                    onSelectedTextChanged: root.selectedPartialText = previewFullText.selectedText

                                    Keys.forwardTo: [clipOverlay.keyScope, clipOverlay.searchField]

                                    Keys.onPressed: event => {
                                        if ((event.key === Qt.Key_C && (event.modifiers & Qt.ControlModifier)) || event.matches(StandardKey.Copy)) {
                                            if (previewFullText.selectedText.length > 0)
                                                root.copyText(previewFullText.selectedText);
                                            else if (previewCard.currentItem)
                                                root.copyItem(previewCard.currentItem.id);
                                            event.accepted = true;
                                        } else if (event.key === Qt.Key_Escape) {
                                            root.closeMenu();
                                            event.accepted = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
