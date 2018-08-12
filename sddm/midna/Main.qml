/***********************************************************************/

import QtQuick 2.7
import QtGraphicalEffects 1.0
import SddmComponents 2.0
import QtQuick.Controls 2.0


Rectangle {
    id: root
    width: 640
    height: 480
    state: "stateLogin"

    readonly property int hMargin: 100
    readonly property int vMargin: 30
    readonly property int buttonSize: 40

    TextConstants { id: textConstants }

    states: [
        State {
            name: "statePower"
            PropertyChanges { target: loginFrame; visible: false}
            PropertyChanges { target: powerFrame; visible: true}
            PropertyChanges { target: sessionFrame; visible: false}
            PropertyChanges { target: userFrame; visible: false}
            PropertyChanges { target: usageFrame; visible: false}
            PropertyChanges { target: bgBlur; radius: 30}
        },
        State {
            name: "stateSession"
            PropertyChanges { target: loginFrame; visible: false}
            PropertyChanges { target: powerFrame; visible: false}
            PropertyChanges { target: sessionFrame; visible: true}
            PropertyChanges { target: userFrame; visible: false}
            PropertyChanges { target: usageFrame; visible: false}
            PropertyChanges { target: bgBlur; radius: 30}
        },
        State {
            name: "stateUser"
            PropertyChanges { target: loginFrame; visible: false}
            PropertyChanges { target: powerFrame; visible: false}
            PropertyChanges { target: sessionFrame; visible: false}
            PropertyChanges { target: userFrame; visible: true}
            PropertyChanges { target: usageFrame; visible: false}
            PropertyChanges { target: bgBlur; radius: 30}
        },
        State {
            name: "stateLogin"
            PropertyChanges { target: loginFrame; visible: true}
            PropertyChanges { target: powerFrame; visible: false}
            PropertyChanges { target: sessionFrame; visible: false}
            PropertyChanges { target: userFrame; visible: false}
            PropertyChanges { target: usageFrame; visible: false}
            PropertyChanges { target: bgBlur; radius: 0}
        },
        State {
            name: "stateUsage"
            PropertyChanges { target: loginFrame; visible: false}
            PropertyChanges { target: powerFrame; visible: false}
            PropertyChanges { target: sessionFrame; visible: false}
            PropertyChanges { target: userFrame; visible: false}
            PropertyChanges { target: usageFrame; visible: true}
            PropertyChanges { target: bgBlur; radius: 30}
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
            source: config.default_background
            fillMode: Image.Tile
            onStatusChanged: {
                if (status == Image.Error && source !== config.default_background) {
                    source = config.default_background
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
            fillMode: Image.PreserveAspectCrop
            source: config.default_background
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
            height: 430
            visible: config.primary_screen_only == "true" ? primaryScreen : true
            anchors {
                centerIn: parent
            }

            PowerFrame {
                id: powerFrame
                anchors.fill: parent
                enabled: root.state == "statePower"
                onNeedClose: {
                    root.state = "stateLogin"
                    if (config.user_name == "select") {
                        loginFrame.passwdInput.forceActiveFocus()
                    } else {
                        loginFrame.input.forceActiveFocus()
                    }
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
                    root.state = "stateLogin"
                    loginFrame.sessionIndex = index
                    loginFrame.passwdInput.forceActiveFocus()
                }
                onNeedClose: {
                    root.state = "stateLogin"
                    loginFrame.passwdInput.forceActiveFocus()
                }
            }

            UserFrame {
                id: userFrame
                anchors.fill: parent
                enabled: root.state == "stateUser"
                onSelected: {
                    root.state = "stateLogin"
                    loginFrame.userName = userName
                    loginFrame.passwdInput.forceActiveFocus()
                }
                onNeedClose: {
                    root.state = "stateLogin"
                    loginFrame.passwdInput.forceActiveFocus()
                }
            }

            LoginFrame {
                id: loginFrame
                anchors.fill: parent
                enabled: root.state == "stateLogin"
                visible: false
                transformOrigin: Item.Top
            }

            UsageFrame {
                id: usageFrame
                anchors.fill: parent
                enabled: root.state == "usageFrame"
                visible: false
                transformOrigin: Item.Top
            }
        }

        Rectangle {
            id: topArea
            anchors {
                top: parent.top
                left: parent.left
            }
            width: parent.width
            height: 64
            color: "#A4BBDA"

            LayoutBox {
                id: layoutBox
                width: 90
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: hMargin
                }
                font.pixelSize: 14
                color: "#A4BBDA"
                borderColor: "#A4BBDA"
                focusColor: "#A4BBDA"
                hoverColor: "#A4BBDA"
                textColor: "#000000"

                arrowIcon: "icons/angle-down.png"
                arrowColor: "#A4BBDA"
            }

            Item {
                id: timeArea
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
                width: parent.width / 3
                height: parent.height

                Label {
                    id: timeText
                    anchors {
                        centerIn: parent
                    }

                    font.family: "raleway"
                    font.pointSize: 16

                    color: "#000000"

                    property bool clock: config.am_pm_clock == "false"

                    function updateTime() {
                        text = new Date().toLocaleString(Qt.locale("en_US"),
                            clock ? "h:mm:ss A" : "dddd MMMM d hh:mm")
                    }
                }

                Timer {
                    interval: 1000
                    repeat: true
                    running: true
                    onTriggered: {
                        timeText.updateTime()
                    }
                }

                Component.onCompleted: {
                    timeText.updateTime()
                }
            }

            Item {
                id: powerArea
                anchors {
                    bottom: parent.bottom
                    right: parent.right
                }
                width: parent.width / 3
                height: parent.height

                Row {
                    spacing: 20
                    anchors.right: parent.right
                    anchors.rightMargin: hMargin
                    anchors.verticalCenter: parent.verticalCenter

                    state: config.user_name

                    states: [
                        State {
                            name: "fill"
                            PropertyChanges { target: userButton; visible: false}
                        },
                        State {
                            name: "select"
                            PropertyChanges { target: userButton; visible: true}
                        }
                    ]


                    ImgButton {
                        id: sessionButton
                        width: buttonSize
                        height: buttonSize
                        visible: sessionFrame.isMultipleSessions()
                        normalImg: "icons/switchframe/session.png"
                        pressImg: "icons/switchframe/session_focus.png"
                        normalColor: "#000000"
                        onClicked: {
                            root.state = "stateSession"
                            sessionFrame.focus = true
                        }
                        onEnterPressed: sessionFrame.currentItem.forceActiveFocus()

                        KeyNavigation.tab: (config.user_name == "select" ? loginFrame.passwdInput : loginFrame.input)
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
                        width: buttonSize
                        height: buttonSize
                        visible: userFrame.isMultipleUsers()

                        normalImg: "icons/switchframe/user.png"
                        pressImg: "icons/switchframe/user_focus.png"
                        normalColor: "#000000"
                        onClicked: {
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
                                return (config.user_name == "select" ? loginFrame.passwdInput : loginFrame.input)
                            }
                        }
                    }

                    ImgButton {
                        id: shutdownButton
                        width: buttonSize
                        height: buttonSize
                        visible: sddm.canPowerOff ? sddm.canPowerOff : "true"

                        normalImg: "icons/switchframe/powermenu.png"
                        pressImg: "icons/switchframe/powermenu_focus.png"
                        normalColor: "#000000"
                        onClicked: {
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
                                return (config.user_name == "select" ? loginFrame.passwdInput : loginFrame.input)
                            }
                        }
                    }
                }
            }

        }
        DropShadow {
            anchors.fill: topArea
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8.0
            samples: 17
            color: "#80000000"
            source: topArea
        }

        MouseArea {
            z: -1
            anchors.fill: parent
            onClicked: {
                root.state = "stateLogin"
                if (config.user_name == "select") {
                    loginFrame.passwdInput.forceActiveFocus()
                } else {
                    loginFrame.input.forceActiveFocus()
                }
            }
        }

        Button {
            id: aupButton
            width: 200
            text: qsTr("Acceptable Use Policy")
            highlighted: true
            background: Rectangle {
                id: aupButtonBack
                color: "#7D9DB2"
                implicitHeight: 40
            }

            font.family: "raleway"

            anchors {
                bottom: parent.bottom
                bottomMargin: 40
                horizontalCenter: parent.horizontalCenter
            }
            onClicked: {
                root.state = "stateUsage"
            }

            onFocusChanged: {
                if (focus) {
                    aupButtonBack.color = "#687180"
                } else {
                    aupButtonBack.color = "#7D9DB2"
                }
            }

            Component.onCompleted: {
                if (!config.aup) {
                    height = 0
                }
            }
        }

        DropShadow {
            id: aupButtonShadow
            anchors.fill: aupButton
            horizontalOffset: 0
            verticalOffset: 1
            radius: 8.0
            samples: 17
            color: "#80000000"
            source: aupButton
        }
    }
}
