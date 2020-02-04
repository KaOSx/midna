import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    id: sessionButton
    height: root.font.pointSize
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter

    property var selectedSession: selectSession.currentIndex
    property string textConstantSession

    ComboBox {
        id: selectSession

        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        hoverEnabled: true

        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        delegate: ItemDelegate {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text {
                text: model.name
                font.pointSize: root.font.pointSize * 0.8
                color: selectSession.highlightedIndex === index ? "white" : root.palette.text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            highlighted: parent.highlightedIndex === index
            background: Rectangle {
                color: selectSession.highlightedIndex === index ? root.palette.text : "transparent"
            }
        }

        indicator {
            visible: false
        }

        contentItem: Text {
            id: displayedItem
            text: (config.TranslateSession || (textConstantSession + ":")) + " " + selectSession.currentText
            color: root.palette.text // parent.down ? root.palette.text : parent.hovered ? Qt.lighter(root.palette.text, 1.8) : root.palette.text
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pointSize: root.font.pointSize * 0.8
            Image {
                source: "icons/angle-down.png"
                anchors.horizontalCenter: parent.left
                anchors.horizontalCenterOffset: selectSession.height * 0.8
            }
        }

        background: Rectangle {
            color: "transparent"
            border.width: parent.visualFocus ? 1 : 0
            border.color: "transparent" // parent.visualFocus ? root.palette.text : "transparent"
            height: parent.visualFocus ? 2 : 0
            width: displayedItem.implicitWidth
            anchors.top: parent.bottom
            anchors.left: parent.left
        }

        popup: Popup {
            id: popupHandler
            y: parent.height - 1
            width: parent.width
            implicitHeight: contentItem.implicitHeight
            padding: 1

            contentItem: ListView {
                clip: false
                implicitHeight: contentHeight
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                width: parent.width
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                border.width: 1
                border.color: root.palette.text
            }

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1 }
            }
        }

        states: [
            State {
                name: "pressed"
                when: selectSession.down
                PropertyChanges {
                    target: displayedItem
                    color: Qt.lighter(config.AccentColor, 1.1)
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.lighter(config.AccentColor, 1.1)
                }
            },
            State {
                name: "hovered"
                when: selectSession.hovered
                PropertyChanges {
                    target: displayedItem
                    color: Qt.lighter(config.AccentColor, 1.3)
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.lighter(config.AccentColor, 1.3)
                }
            },
            State {
                name: "focused"
                when: selectSession.visualFocus
                PropertyChanges {
                    target: displayedItem
                    color: config.AccentColor
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: config.AccentColor
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]

    }

}
