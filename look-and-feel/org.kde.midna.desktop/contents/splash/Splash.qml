/***************************************************************************
 *   Copyright (C) 2017-2018 Anke Boersma <demm@kaosx.us>       *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.          *
 ***************************************************************************/

import QtQuick 2.7
import QtGraphicalEffects 1.0

Image {
    id: root
    source: "images/background.png"

    property int stage


    Item {
        clip: true

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: logo.size / 8
        width: 300
        height: 100

        Image {
            id: plasma
            property real size: units.gridUnit * 2

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -20

            source: "images/plasma.svgz"

            sourceSize.width: 50
            sourceSize.height: 50

            states: [
                State {
                    name: "1"
                    when: root.stage >= 1 && root.stage < 6
                    PropertyChanges {
                        target: plasma
                        anchors.bottomMargin: 30
                    }
                },
                State {
                    name: "4"
                    when: root.stage >= 6
                    PropertyChanges {
                        target: plasma
                        anchors.bottomMargin: 120
                    }
                }
            ]

            transitions: Transition {
                NumberAnimation {
                    properties: "anchors.bottomMargin"
                    easing.type: Easing.InOutQuad
                    duration: 1000
                }
            }
        }
    }

    Item {
        id: logoBox
        clip: true
        width: 200
        height: 140

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.verticalCenter
        anchors.topMargin: -15

        Image {
            id: logo
            property real size: units.gridUnit * 8

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            source: "images/kde.svgz"

            sourceSize.width: 100
            sourceSize.height: 100

            states: [
                State {
                    when: root.stage >= 1 && root.stage < 5
                    PropertyChanges {
                        target: logo
                        anchors.topMargin: 15
                    }
                },
                State {
                    when: root.stage >= 5
                    PropertyChanges {
                        target: logo
                        anchors.topMargin: (logo.size + 200) * -1;
                    }
                }
            ]

            transitions: Transition {
                NumberAnimation {
                    properties: "anchors.topMargin"
                    easing.type: Easing.InOutQuad
                    duration: 1000
                }
            }
        }

        states: [
            State {
                name: "1"
                when: root.stage >= 1
                PropertyChanges {
                    target: logoBox
                    anchors.topMargin: 15
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "anchors.topMargin"
                easing.type: Easing.InOutQuad
                duration: 1000
            }
        }
    }


    Rectangle {
        id: glowingBar
        anchors.centerIn: root

        width: 300
        height: 5

        radius: 6
        opacity: 0


        gradient: Gradient {
            GradientStop { position: 0.0; color: "#3498db" }
            GradientStop { position: 1.0; color: "#124364" }
        }

        states: [
            State {
                name: "3"
                when: root.stage >= 3
                PropertyChanges {
                    target: glowingBar
                    opacity: 1
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "opacity"
                easing.type: Easing.InOutQuad
                duration: 1000
            }
        }

    }

    Item {
        id: messageBox

        width: 300;
        height: message.height

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: glowingBar.top

        clip: true

        Text {
            id: message
            text: i18n("Plasma for KaOS")
            color: "#3498db"
            font.pointSize: 18
            font.weight: Font.Light

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: message.height

            states: [
                State {
                    name: "visible"
                    when: root.stage >= 6
                    PropertyChanges {
                        target: message
                        anchors.topMargin: - 5
                    }
                }
            ]

            transitions: Transition {
                NumberAnimation {
                    properties: "anchors.topMargin"
                    easing.type: Easing.InOutQuad
                    duration: 1000
                }
            }
        }
    }
}
