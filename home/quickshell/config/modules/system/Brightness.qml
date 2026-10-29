pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../components"

SystemItem {
    id: root

    property int brightness: 80

    FileView {
        id: brightnessFile
        path: `${Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")}/last_brightness`
        watchChanges: true

        // Обязательно перезагружаем буфер при изменении файла на диске
        onFileChanged: reload()

        onLoaded: {
            const val = parseInt(text().trim(), 10);
            // Игнорируем пустой файл в момент O_TRUNC, чтобы не прыгало на 100%
            if (!isNaN(val)) {
                root.brightness = Math.max(0, Math.min(100, val));
            }
        }
    }

    readonly property string icon: {
        if (brightness <= 25)
            return "󰃞";
        if (brightness <= 50)
            return "󰃝";
        if (brightness <= 75)
            return "󰃟";
        return "󰃠";
    }

    BarText {
        width: 16
        horizontalAlignment: Text.AlignHCenter
        text: root.icon
        color: Theme.mauve
    }

    BarText {
        width: 32
        horizontalAlignment: Text.AlignLeft
        text: `${root.brightness}%`
        color: Theme.text
    }

    WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
            if (event.angleDelta.y > 0) {
                Quickshell.execDetached(["ddc-brightness", "up"]);
            } else if (event.angleDelta.y < 0) {
                Quickshell.execDetached(["ddc-brightness", "down"]);
            }
        }
    }
}
