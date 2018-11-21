import QtQuick 2.0
import QtQuick.Layouts 1.11

Rectangle {
    id: button
    color: "transparent"
    Layout.fillWidth: true
    height: buttonText.height + 10

    property alias text: buttonText.text
    property alias textColor: buttonText.color
    property alias textSize: buttonText.font.pixelSize
    property alias backgroundColor: button.color

    signal clicked
    
    states: [
        State {
            name: "Hovering"
            PropertyChanges {
                target: button
                color: "#A4BBDA"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: button
                color: "#000"
            }
        }
    ]


    Text {
        id: buttonText
        font.pixelSize: 14
        color: "#dbe3f0"
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: { button.state='Hovering'}
        onExited: { button.state=''}
        onClicked: { button.clicked();}
        onPressed: button.opacity = 0.6
        onReleased: button.opacity = 1
    }
}
