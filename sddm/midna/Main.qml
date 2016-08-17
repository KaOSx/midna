/*
 *   Copyright 2016 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.2

import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaCore.ColorScope {
    id: root
    colorGroup: PlasmaCore.Theme.ComplementaryColorGroup

    width: 1600
    height: 900

    property string notificationMessage

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    Repeater {
        model: screenModel

        Background {
            x: geometry.x; y: geometry.y; width: geometry.width; height:geometry.height
            source: config.background
            fillMode: Image.PreserveAspectCrop
        }
    }
    
    Rectangle {
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        property real scale: geometry.width / 1600
        color: "transparent"
        transformOrigin: Item.Top

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height * 0.4
            anchors.verticalCenterOffset: 0
            color: "#F0F5F5F5"
            //color: "#33000000"

            Rectangle {
                color: "#31A3DD"
                width: 145
                height: 25
                anchors {
                        bottom: parent.bottom
                        bottomMargin: 20
                        left: parent.left
                        leftMargin: 200
                    }
            
                KeyboardButton {
                }
            }
            
            Rectangle {
                color: "#31A3DD"
                width: 165
                height: 25
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 20
                    right: parent.right
                    rightMargin: 200
                }

                SessionButton {
                    id: sessionButton
                }
            }
            
            Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 2
            color: "#646464"
            }
            
            Rectangle {
            width: parent.width
            height: 2
            color: "#646464"
            }
        }
    }


    Clock {
        anchors.top: parent.top
        anchors.topMargin: units.gridUnit * 3
        anchors.horizontalCenter: parent.horizontalCenter
    }


    StackView {
        id: mainStack
        anchors {
            top: parent.top
            bottom: footer.top
            left: parent.left
            right: parent.right
            topMargin: footer.height // effectively centre align within the view
        }
        focus: true //StackView is an implicit focus scope, so we need to give this focus so the item inside will have it
        initialItem: Login {
            userListModel: userModel
            userListCurrentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0

            notificationMessage: root.notificationMessage

            actionItems: [
                ActionButton {
                    iconSource: "/usr/share/icons/midna/actions/24/system-suspend.svg"
                    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Suspend")
                    onClicked: sddm.suspend()
                    enabled: sddm.canSuspend
                },
                ActionButton {
                    iconSource: "/usr/share/icons/midna/actions/24/system-reboot.svg"
                    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Restart")
                    onClicked: sddm.reboot()
                    enabled: sddm.canReboot
                },
                ActionButton {
                    iconSource: "/usr/share/icons/midna/actions/24/system-shutdown.svg"
                    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Shutdown")
                    onClicked: sddm.powerOff()
                    enabled: sddm.canPowerOff
                },
                ActionButton {
                    iconSource: "/usr/share/icons/midna/actions/24/system-search.svg"
                    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Different User")
                    onClicked: mainStack.push(userPrompt)
                    enabled: true
                }
            ]

            onLoginRequest: {
                root.notificationMessage = ""
                sddm.login(username, password, sessionButton.currentIndex)
            }
        }

        Behavior on opacity {
            OpacityAnimator {
                duration: units.longDuration
            }
        }

    }

    Component {
        id: userPrompt
        Login {
            showUsernamePrompt: true
            notificationMessage: root.notificationMessage

            userListModel: QtObject {
                property string name: i18nd("plasma_lookandfeel_org", "Login as different user")
                property string iconSource: ""
            }

            onLoginRequest: {
                root.notificationMessage = ""
                sddm.login(username, password, sessionButton.currentIndex)
            }

            actionItems: [
                ActionButton {
                    iconSource: "/usr/share/icons/midna/actions/24/go-previous-view.svg" 
                    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Back")
                    onClicked: mainStack.pop()
                }
            ]
        }
    }

    //Footer
    RowLayout {
        id: footer
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: units.smallSpacing
        }

        Behavior on opacity {
            OpacityAnimator {
                duration: units.longDuration
            }
        }

      //  KeyboardButton {
      //  }

      //  SessionButton {
      //      id: sessionButton
      //  }

      //  Item {
      //      Layout.fillWidth: true
      //  }
    }

    Connections {
        target: sddm
        onLoginFailed: {
            notificationMessage = i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Login Failed")
        }
        onLoginSucceeded: {
            //note SDDM will kill the greeter at some random point after this
            //there is no certainty any transition will finish, it depends on the time it
            //takes to complete the init
            mainStack.opacity = 0
            footer.opacity = 0
        }
    }

    onNotificationMessageChanged: {
        if (notificationMessage) {
            notificationResetTimer.start();
        }
    }

    Timer {
        id: notificationResetTimer
        interval: 3000
        onTriggered: notificationMessage = ""
    }

}
