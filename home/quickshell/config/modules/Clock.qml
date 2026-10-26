pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import ".."
import "../components"

Island {
    id: root

    clickable: true
    spacing: 6

    readonly property var daysShort: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
    readonly property var monthsNom: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]

    // Просыпается ровно раз в минуту на 00 секундах (0% нагрузки на CPU)
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    property date viewDate: new Date()
    property bool popupOpen: false

    function shiftMonth(delta: int) {
        // Всегда ставим 1-е число, чтобы 31-го числа setMonth не перескакивал через месяц
        root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() + delta, 1);
    }

    BarText {
        text: "󰥔"
        color: Theme.mauve
    }

    BarText {
        text: Qt.formatTime(clock.date, "hh:mm")
    }

    BarText {
        text: "󰸗"
        color: Theme.mauve
    }

    BarText {
        text: `${root.daysShort[clock.date.getDay()]} ${Qt.formatDate(clock.date, "dd.MM.yyyy")}`
    }

    onClicked: {
        if (!root.popupOpen) {
            root.viewDate = new Date(clock.date.getFullYear(), clock.date.getMonth(), 1);
        }
        root.popupOpen = !root.popupOpen;
    }

    // Создает окно календаря в ОЗУ только тогда, когда оно открыто
    LazyLoader {
        active: root.popupOpen

        // qmllint disable unqualified
        PopupWindow {
            id: calendarPopup
            readonly property var win: root.QsWindow.window

            anchor.window: win ?? null
            anchor.rect.x: win ? Math.min(Math.max(8, Math.round((win.width - calendarCard.implicitWidth) / 2)), win.width - calendarCard.implicitWidth - 8) : 0
            anchor.rect.y: win ? win.height : 0
            anchor.margins.top: 6

            color: "transparent"
            visible: true
            grabFocus: true

            // Если окно закрылось по потере фокуса (клик мимо), синхронизируем флаг
            onVisibleChanged: {
                if (!visible)
                    root.popupOpen = false;
            }

            implicitWidth: calendarCard.implicitWidth
            implicitHeight: calendarCard.implicitHeight

            PopupCard {
                id: calendarCard
                implicitWidth: 260
                implicitHeight: 280

                // Позволяет листать месяцы колесиком мыши прямо над календарем
                WheelHandler {
                    target: calendarCard
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    onWheel: event => root.shiftMonth(event.angleDelta.y < 0 ? 1 : -1)
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    // Заголовок месяца и навигация < Месяц Год >
                    Row {
                        width: parent.width

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 4
                            color: prevHover.hovered ? Theme.surface : "transparent"

                            BarText {
                                anchors.centerIn: parent
                                text: "󰅁"
                                color: Theme.mauve
                            }

                            HoverHandler {
                                id: prevHover
                                cursorShape: Qt.PointingHandCursor
                            }

                            TapHandler {
                                onTapped: root.shiftMonth(-1)
                            }
                        }

                        // Кнопка возврата к текущей дате («Сегодня»)
                        Rectangle {
                            id: monthBtn
                            width: parent.width - 48
                            height: 24
                            radius: 4
                            color: monthHover.hovered ? Theme.surface : "transparent"

                            readonly property bool isCurrentMonth: root.viewDate.getMonth() === clock.date.getMonth() && root.viewDate.getFullYear() === clock.date.getFullYear()

                            BarText {
                                anchors.centerIn: parent
                                text: `${root.monthsNom[root.viewDate.getMonth()]} ${root.viewDate.getFullYear()}`
                                color: monthBtn.isCurrentMonth ? Theme.text : Theme.mauve
                                font.bold: true
                            }

                            HoverHandler {
                                id: monthHover
                                cursorShape: Qt.PointingHandCursor
                            }

                            TapHandler {
                                onTapped: root.viewDate = new Date(clock.date.getFullYear(), clock.date.getMonth(), 1)
                            }
                        }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 4
                            color: nextHover.hovered ? Theme.surface : "transparent"

                            BarText {
                                anchors.centerIn: parent
                                text: "󰅂"
                                color: Theme.mauve
                            }

                            HoverHandler {
                                id: nextHover
                                cursorShape: Qt.PointingHandCursor
                            }

                            TapHandler {
                                onTapped: root.shiftMonth(1)
                            }
                        }
                    }

                    // Дни недели: Пн Вт Ср Чт Пт Сб Вс
                    Grid {
                        columns: 7
                        columnSpacing: 4
                        width: parent.width

                        Repeater {
                            model: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                            Item {
                                required property string modelData
                                required property int index
                                width: 30
                                height: 20
                                BarText {
                                    anchors.centerIn: parent
                                    text: parent.modelData
                                    color: parent.index >= 5 ? Theme.red : Theme.mauve
                                    font.pixelSize: 11
                                }
                            }
                        }
                    }

                    // Сетка чисел месяца (42 ячейки)
                    Grid {
                        id: daysGrid
                        columns: 7
                        columnSpacing: 4
                        rowSpacing: 4
                        width: parent.width

                        readonly property int todayDay: clock.date.getDate()
                        readonly property bool isCurrentMonthAndYear: root.viewDate.getMonth() === clock.date.getMonth() && root.viewDate.getFullYear() === clock.date.getFullYear()

                        readonly property var daysList: {
                            const year = root.viewDate.getFullYear();
                            const month = root.viewDate.getMonth();

                            const firstDayOfWeek = (new Date(year, month, 1).getDay() + 6) % 7;
                            const daysInMonth = new Date(year, month + 1, 0).getDate();
                            const daysInPrevMonth = new Date(year, month, 0).getDate();

                            const list = [];

                            for (let i = firstDayOfWeek - 1; i >= 0; --i) {
                                list.push({
                                    day: daysInPrevMonth - i,
                                    currentMonth: false
                                });
                            }
                            for (let i = 1; i <= daysInMonth; ++i) {
                                list.push({
                                    day: i,
                                    currentMonth: true
                                });
                            }
                            const remaining = 42 - list.length;
                            for (let i = 1; i <= remaining; ++i) {
                                list.push({
                                    day: i,
                                    currentMonth: false
                                });
                            }
                            return list;
                        }

                        Repeater {
                            model: daysGrid.daysList

                            Rectangle {
                                id: dayCell
                                required property var modelData
                                required property int index

                                readonly property bool isToday: modelData.currentMonth && daysGrid.isCurrentMonthAndYear && modelData.day === daysGrid.todayDay
                                readonly property bool isWeekend: (index % 7) >= 5

                                width: 30
                                height: 26
                                radius: 6

                                color: isToday ? Theme.mauve : (dayHover.hovered ? Theme.surface : "transparent")

                                BarText {
                                    anchors.centerIn: parent
                                    text: dayCell.modelData.day
                                    color: dayCell.isToday ? Theme.darkText : (dayCell.isWeekend && dayCell.modelData.currentMonth ? Theme.red : Theme.text)
                                    opacity: dayCell.modelData.currentMonth ? 1.0 : 0.3
                                    font.pixelSize: 12
                                    font.bold: dayCell.isToday || (dayCell.isWeekend && dayCell.modelData.currentMonth)
                                }

                                HoverHandler {
                                    id: dayHover
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
