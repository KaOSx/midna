import QtQuick 2.0
import QtQuick.Layouts 1.11

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Rectangle {
    id: button
    color: "transparent"
    width: 120
    height: buttonText.height + 10
    radius: 5

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
                color: "#303030"
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
        color: "#ffffff"
        anchors.centerIn: parent
    }
    
    PlasmaCore.DataSource {
        id: keystateCaps
        engine: "keystate"
        connectedSources: "Caps Lock"
    }
    
    text: {
        var text = ""
        if (keystateCaps.data["Caps Lock"]["Locked"]) {
            text += "Caps Lock is ON!"
            button.state='Hovering'
        }
        return text
    }

    onClicked: keyboard.capsLock = !keyboard.capsLock

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor;
        onExited: { button.state=''}
        onClicked: { button.clicked();}
        onPressed: button.opacity = 0.6
        onReleased: button.opacity = 1
    }
}
