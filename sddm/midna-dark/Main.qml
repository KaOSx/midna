/***************************************************************************
* Copyright (c) 2015 Mikkel Oscar Lyderik <mikkeloscar@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

import "Components"

Rectangle {
    id: container

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
        }

        onLoginFailed: {
            errorMessage.text = textConstants.loginFailed
            password.text = ""
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 200
        height: 120
        color: "transparent"
        visible: primaryScreen

        Column {
            id: rebootColumn
            spacing: 5

            ImageButton {
                id: btnReboot
                anchors.horizontalCenter: parent.horizontalCenter
                width: 50
                source: "reboot.png"

                visible: sddm.canReboot

                onClicked: sddm.reboot()

                KeyNavigation.backtab: password; KeyNavigation.tab: btnPoweroff
            }

            Text {
                text: "Restart"
                color: "#dddddd"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Column {
            id: poweroffColumn
            spacing: 5
            anchors.right: parent.right

            ImageButton {
                id: btnPoweroff
                anchors.horizontalCenter: parent.horizontalCenter
                width: 50
                source: "poweroff.png"

                visible: sddm.canPowerOff

                onClicked: sddm.powerOff()

                KeyNavigation.backtab: btnReboot; KeyNavigation.tab: session
            }

            Text {
                text: "Poweroff"
                color: "#dddddd"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Rectangle {
        id: loginArea
        anchors.fill: parent
        color: "transparent"
        visible: primaryScreen

        Column {
         id: mainColumn
         anchors.centerIn: parent
         anchors.verticalCenterOffset: -100
         spacing: 12

            Image {
                id: logo
                width: 177
                height: 177
                fillMode: Image.PreserveAspectFit
                transformOrigin: Item.Center
                source: config.logo
            }

            TextBox {
                id: name
                width: 177
                text: userModel.lastUser
                font.pixelSize: 16
                radius: 15
                color: "#77000000"
                borderColor: "#77000000"
                textColor: "white"

                KeyNavigation.backtab: layoutBox; KeyNavigation.tab: password
            }

            PasswordBox {
                id: password
                width: 177
                font.pixelSize: 16
                radius: 15

                focus: true
                Timer {
                    interval: 200
                    running: true
                    onTriggered: password.forceActiveFocus()
                }

                KeyNavigation.backtab: name; KeyNavigation.tab: btnReboot

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key ===
                            Qt.Key_Enter) {
                            sddm.login(name.text, password.text, session.index)
                            event.accepted = true
                    }
                }
            }

            Text {
                id: errorMessage
                anchors.horizontalCenter: parent.horizontalCenter
                text: " "
                font.pixelSize: 12
                color: "white"
            }
        }
    }

    Rectangle {
        id: actionBar
        anchors.top: parent.top;
        color: "#22000000"
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width; height: 30
        visible: primaryScreen

        Row {
            anchors.left: parent.left
            anchors.margins: 5
            height: parent.height
            spacing: 20

            // Session
            CustomComboBox {
                id: session
                height: parent.height
                color: "transparent"
                borderColor: "transparent"
                borderWidth: 0
                textColor: "white"
                dropdownColor: "#22000000"
                hoverColor: "#77000000"
                // width: 245
                anchors.verticalCenter: parent.verticalCenter

                arrowIcon: "angle-down.png"

                model: sessionModel
                index: sessionModel.lastIndex

                font.pixelSize: 14

                KeyNavigation.backtab: btnPoweroff; KeyNavigation.tab: layoutBox
            }

            // Keyboard Layout
            CustomLayoutBox {
                id: layoutBox
                width: 50
                disableText: true
                color: "transparent"
                borderColor: "transparent"
                borderWidth: 0
                textColor: "white"
                dropdownColor: "#22000000"
                hoverColor: "#77000000"
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14

                arrowIcon: "angle-down.png"

                KeyNavigation.backtab: session; KeyNavigation.tab: name
            }
        }

        // Clock
        Row {
            height: parent.height
            anchors.right: parent.right
            anchors.margins: 5
            spacing: 5

            InlineClock {
            }
        }
    }
}
