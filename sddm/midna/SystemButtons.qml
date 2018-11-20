import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import SddmComponents 2.0

RowLayout {

    spacing: root.font.pointSize

    property var suspend: ["Suspend", config.TranslateSuspend || textConstants.suspend, sddm.canSuspend]
    property var reboot: ["Reboot", config.TranslateReboot || textConstants.reboot, sddm.canReboot]
    property var shutdown: ["Shutdown", config.TranslateShutdown || textConstants.shutdown, sddm.canPowerOff]

    property Control exposedLogin

    Repeater {

        model: [suspend, reboot, shutdown]

        RoundButton {
            enabled: modelData[2]
            text: modelData[1]
            font.pointSize: root.font.pointSize * 0.8
            Layout.alignment: Qt.AlignHCenter
            icon.source: modelData ? Qt.resolvedUrl("icons/" + modelData[0] + ".svgz") : ""
            icon.height: 2 * Math.round((root.font.pointSize * 3) / 2)
            icon.width: 2 * Math.round((root.font.pointSize * 3) / 2)
            display: AbstractButton.TextUnderIcon
            opacity: modelData[2] ? 1 : 0.9
            hoverEnabled: true
            palette.buttonText: root.palette.text
            background: Rectangle {
                height: 2
                color: "transparent"
                width: parent.width
                border.width: parent.visualFocus ? 1 : 0
                border.color: "transparent"
                anchors.top: parent.bottom
            }
            Keys.onReturnPressed: clicked()
            onClicked: {
                parent.forceActiveFocus()
                index == 0 ? sddm.suspend() : index == 1 ? sddm.reboot() : sddm.powerOff()
            }
            KeyNavigation.up: exposedLogin
            KeyNavigation.left: index == 0 ? exposedLogin : parent.children[index-1]

            states: [
                State {
                    name: "pressed"
                    when: parent.children[index].down
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: Qt.lighter("white", 1.1)
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: Qt.lighter("white", 1.3)
                    }
                },
                State {
                    name: "hovered"
                    when: parent.children[index].hovered
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: Qt.lighter("white", 1.5)
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: Qt.lighter("white", 1.7)
                    }
                },
                State {
                    name: "focused"
                    when: parent.children[index].visualFocus
                    PropertyChanges {
                        target: parent.children[index]
                        palette.buttonText: Qt.lighter("white", 1.3)
                    }
                    PropertyChanges {
                        target: parent.children[index].background
                        border.color: Qt.lighter("white", 1.5)
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "palette.buttonText, border.color"
                        duration: 150
                    }
                }
            ]

        }

    }

}
