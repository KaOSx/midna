/***********************************************************************/

import QtQuick 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents


Rectangle {
    id: root
    width: 640
    height: 480
    state: "stateLogin"

    readonly property int hMargin: 100
    readonly property int vMargin: 75
    readonly property int m_powerButtonSize: 40
    readonly property color textColor: "#414546"

    TextConstants { id: textConstants }

    states: [
        State {
            name: "statePower"
            PropertyChanges { target: loginFrame; opacity: 0}
            PropertyChanges { target: powerFrame; opacity: 1}
            PropertyChanges { target: sessionFrame; opacity: 0}
            PropertyChanges { target: userFrame; opacity: 0}
            PropertyChanges { target: bgBlur; radius: 30}
        },
        State {
            name: "stateSession"
            PropertyChanges { target: loginFrame; opacity: 0}
            PropertyChanges { target: powerFrame; opacity: 0}
            PropertyChanges { target: sessionFrame; opacity: 1}
            PropertyChanges { target: userFrame; opacity: 0}
            PropertyChanges { target: bgBlur; radius: 30}
        },
        State {
            name: "stateUser"
            PropertyChanges { target: loginFrame; opacity: 0}
            PropertyChanges { target: powerFrame; opacity: 0}
            PropertyChanges { target: sessionFrame; opacity: 0}
            PropertyChanges { target: userFrame; opacity: 1}
            PropertyChanges { target: bgBlur; radius: 30}
        },
        State {
            name: "stateLogin"
            PropertyChanges { target: loginFrame; opacity: 1}
            PropertyChanges { target: powerFrame; opacity: 0}
            PropertyChanges { target: sessionFrame; opacity: 0}
            PropertyChanges { target: userFrame; opacity: 0}
            PropertyChanges { target: bgBlur; radius: 0}
        }

    ]
    transitions: Transition {
        PropertyAnimation { duration: 100; properties: "opacity";  }
        PropertyAnimation { duration: 300; properties: "radius"; }
    }

    Repeater {
        model: screenModel
        Background {
            x: geometry.x; y: geometry.y; width: geometry.width; height:geometry.height
            source: config.background
            fillMode: Image.Tile
            onStatusChanged: {
                if (status == Image.Error && source !== config.defaultBackground) {
                    source = config.defaultBackground
                }
            }
        }
    }

    Item {
        id: mainFrame
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height

        Image {
            id: mainFrameBackground
            anchors.fill: parent
            source: "background.png"
        }

        FastBlur {
            id: bgBlur
            anchors.fill: mainFrameBackground
            source: mainFrameBackground
            radius: 0
        }

        Item {
            id: centerArea
            width: parent.width
            height: parent.height / 3
            anchors.top: parent.top
            anchors.topMargin: parent.height / 5

            PowerFrame {
                id: powerFrame
                anchors.fill: parent
                enabled: root.state == "statePower"
                onNeedClose: {
                    root.state = "stateLogin"
                    loginFrame.input.forceActiveFocus()
                }
                onNeedShutdown: sddm.powerOff()
                onNeedRestart: sddm.reboot()
                onNeedSuspend: sddm.suspend()
            }

            SessionFrame {
                id: sessionFrame
                anchors.fill: parent
                enabled: root.state == "stateSession"
                onSelected: {
                    console.log("Selected session:", index)
                    root.state = "stateLogin"
                    loginFrame.sessionIndex = index
                    loginFrame.input.forceActiveFocus()
                }
                onNeedClose: {
                    root.state = "stateLogin"
                    loginFrame.input.forceActiveFocus()
                }
            }

            UserFrame {
                id: userFrame
                anchors.fill: parent
                enabled: root.state == "stateUser"
                onSelected: {
                    console.log("Select user:", userName)
                    root.state = "stateLogin"
                    loginFrame.userName = userName
                    loginFrame.input.forceActiveFocus()
                }
                onNeedClose: {
                    root.state = "stateLogin"
                    loginFrame.input.forceActiveFocus()
                }
            }

            LoginFrame {
                id: loginFrame
                anchors.fill: parent
                enabled: root.state == "stateLogin"
                opacity: 0
                transformOrigin: Item.Top
            }
        }

        Item {
            id: timeArea
            visible: ! loginFrame.isProcessing
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width / 3
            height: parent.height / 5
            
            KeyboardButton {
                 anchors {
                     horizontalCenter: parent.horizontalCenter
                     topMargin: 25
                     bottomMargin: 5
                 }
            }

            Text {
                id: timeText
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: dateText.top
                    bottomMargin: 5
                }

                font.pointSize: 50
                color: textColor
                font.family: "Raleway"

                function updateTime() {
                    text = new Date().toLocaleString(Qt.locale("en_US"), "hh:mm")
                }
            }

            Text {
                id: dateText
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: vMargin
                }

                font.pointSize: 18
                color: textColor
                font.family: "Raleway"

                function updateDate() {
                    text = new Date().toLocaleString(Qt.locale("en_US"), "yyyy-MM-dd dddd")
                }
            }

            Timer {
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    timeText.updateTime()
                    dateText.updateDate()
                }
            }

            Component.onCompleted: {
                timeText.updateTime()
                dateText.updateDate()
            }
        }

        Item {
            id: powerArea
            visible: ! loginFrame.isProcessing
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width / 3
            height: parent.height / 7

            Row {
                spacing: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                ImgButton {
                    id: sessionButton
                    width: m_powerButtonSize
                    height: m_powerButtonSize
                    visible: sessionFrame.isMultipleSessions()
                    normalImg: sessionFrame.getCurrentSessionIconIndicator()
                    onClicked: {
                        root.state = "stateSession"
                        sessionFrame.focus = true
                    }
                    onEnterPressed: sessionFrame.currentItem.forceActiveFocus()

                    KeyNavigation.tab: loginFrame.input
                    KeyNavigation.backtab: {
                        if (userButton.visible) {
                            return userButton
                        }
                        else {
                            return shutdownButton
                        }
                    }
                }

                ImgButton {
                    id: userButton
                    width: m_powerButtonSize
                    height: m_powerButtonSize
                    visible: userFrame.isMultipleUsers()

                    normalImg: "icons/switchframe/userswitch_normal_g.png"
                    hoverImg: "icons/switchframe/userswitch_hover.png"
                    pressImg: "icons/switchframe/userswitch_press.png"
                    onClicked: {
                        console.log("Switch User...")
                        root.state = "stateUser"
                        userFrame.focus = true
                    }
                    onEnterPressed: userFrame.currentItem.forceActiveFocus()
                    KeyNavigation.backtab: shutdownButton
                    KeyNavigation.tab: {
                        if (sessionButton.visible) {
                            return sessionButton
                        }
                        else {
                            return loginFrame.input
                        }
                    }
                }

                ImgButton {
                    id: shutdownButton
                    width: m_powerButtonSize
                    height: m_powerButtonSize
                    visible: true//sddm.canPowerOff

                    normalImg: "icons/switchframe/shutdown_normal_g.png"
                    hoverImg: "icons/switchframe/shutdown_hover.png"
                    onClicked: {
                        console.log("Show shutdown menu")
                        root.state = "statePower"
                        powerFrame.focus = true
                    }
                    onEnterPressed: powerFrame.shutdown.focus = true
                    KeyNavigation.backtab: loginFrame.button
                    KeyNavigation.tab: {
                        if (userButton.visible) {
                            return userButton
                        }
                        else if (sessionButton.visible) {
                            return sessionButton
                        }
                        else {
                            return loginFrame.input
                        }
                    }
                }
            }
        }

        MouseArea {
            z: -1
            anchors.fill: parent
            onClicked: {
                root.state = "stateLogin"
                loginFrame.input.forceActiveFocus()
            }
        }
    }
}
