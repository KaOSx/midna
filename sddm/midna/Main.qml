/***********************************************************************/


import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    width: 640
    height: 480

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "navy"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            errorMessage.color = "navy"
            errorMessage.text = textConstants.loginFailed
        }
    }

    Repeater {
        model: screenModel
        Background {
            x: geometry.x; y: geometry.y; width: geometry.width; height:geometry.height
            property real ratio: geometry.width / geometry.height
            source: "background.png"
            fillMode: Image.Stretch
            onStatusChanged: {
                if (status == Image.Error && source != config.defaultBackground) {
                    source = config.defaultBackground
                }
            }
        }
    }

    Rectangle {
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        property real scale: geometry.width / 1920
        color: "transparent"
        transformOrigin: Item.Top

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: 300
            anchors.verticalCenterOffset: 0
            color: "#FFFFFFFF"
            
            Clock {
            id: clock
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 100 - parent.width / 3

            color: "#31A3DD"
            timeFont.family: "URW Chancery L"
            dateFont.family: "Droid Sans"
            }

            Column {
                id: mainColumn
                height: 116
                width: 300
                spacing: 4
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 9
                anchors.horizontalCenterOffset: 0

                Row {
                    width: parent.width
                    spacing: 4
                    Text {
                        id: lblName
                        width: parent.width * 0.30; height: 30
                        color: "#31A3DD"
                        text: textConstants.userName
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        font.pixelSize: 12
                    }

                    TextBox {
                        id: name
                        width: parent.width * 0.7; height: 30
                        text: userModel.lastUser
                        font.pixelSize: 14

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing : 4
                    Text {
                        id: lblPassword
                        width: parent.width * 0.3; height: 30
                        color: "#31A3DD"
                        text: textConstants.password
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        font.pixelSize: 12
                    }

                    PasswordBox {
                        id: password
                        width: parent.width * 0.7; height: 30
                        font.pixelSize: 14
                        tooltipBG: "grey"

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, session.index)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textConstants.prompt
                        color: "#31A3DD"
                        font.bold: true
                        font.pixelSize: 16
                    }
                }
            }
            
            Column {
                id: contrColumn
                height: 30
                width: 300
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 100
                anchors.horizontalCenterOffset: 0
                anchors.margins: 5
            
                Row {
                    width: parent.width
                    spacing: 4

                    Text {
                        id: lblSession
                        width: parent.width * 0.20; height: 30
                        color: "#31A3DD"
                        text: textConstants.session
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                        font.pixelSize: 12
                    }

                    ComboBox {
                        id: session
                        width: parent.width * 0.30; height: 30
                        anchors.verticalCenter: parent.verticalCenter

                        arrowIcon: "angle-down.png"

                        model: sessionModel
                        index: sessionModel.lastIndex
                        

                        KeyNavigation.backtab: password; KeyNavigation.tab: loginButton
                    }

                    Text {
                        width: parent.width * 0.30; height: 30
                        color: "#31A3DD"

                        text: textConstants.layout
                        font.bold: true
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    LayoutBox {
                        id: layoutBox
                        width: parent.width * 0.30; height: 30
                        anchors.verticalCenter: parent.verticalCenter

                        font.pixelSize: 14

                        arrowIcon: "angle-down.png"

                        KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                    }
                }
            }
            Column {
                spacing: 4
                property int btnWidth: Math.max(loginButton.implicitWidth,
                                                shutdownButton.implicitWidth,
                                                rebootButton.implicitWidth, 100) + 8
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: parent.width / 2.8 - btnWidth

                Button {
                    id: loginButton
                    text: textConstants.login
                    width: parent.btnWidth
                    height: 40
                    color: "#31A3DD"

                    onClicked: sddm.login(name.text, password.text, session.index)

                    KeyNavigation.backtab: loginButton; KeyNavigation.tab: shutdownButton
                }

                Button {
                    id: shutdownButton
                    text: textConstants.shutdown
                    width: parent.btnWidth
                    height: 40
                    color: "#31A3DD"

                    onClicked: sddm.powerOff()

                    KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                }

                Button {
                    id: rebootButton
                    text: textConstants.reboot
                    width: parent.btnWidth
                    height: 40
                    color: "#31A3DD"

                    onClicked: sddm.reboot()

                    KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
