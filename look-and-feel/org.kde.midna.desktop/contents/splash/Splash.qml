/***************************************************************************
 *   Copyright (C) 2017-2020 Anke Boersma <demm@kaosx.us>       *
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
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.2

Image {
    id: root
    source: "images/background.png"

    property int stage
    
        Rectangle {
        id: ind
        anchors.centerIn: root
        anchors.verticalCenterOffset: 0.4 * parent.height

        opacity: 0

        Controls.ProgressBar {
            from: 0
            to: 100
            indeterminate: true
            Layout.maximumWidth: 300
            anchors.centerIn: parent
        }

        states: [
            State {
                name: "2"
                when: root.stage >= 1
                PropertyChanges {
                    target: ind
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
        id: logoBox
        clip: true
        width: 200
        height: 140

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 1.5

        Image {
            id: logo
            property real size: 80

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            source: "images/KaOS.svgz"

            sourceSize.width: 80
            sourceSize.height: 80

            states: [
                State {
                    when: root.stage >= 1 && root.stage < 6
                    PropertyChanges {
                        target: logo
                        anchors.topMargin: 25
                    }
                },
                State {
                    when: root.stage >= 5
                    PropertyChanges {
                        target: logo
                        anchors.topMargin: (logo.size + 200) * 1;
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

    Item {
        id: messageBox

        width: 300;
        height: message.height

        anchors.right: parent.right
        anchors.bottom: parent.bottom

        clip: true

        Text {
            id: message
            text: i18n("Plasma for KaOS")
            color: "#1F1F1F"
            font { family: "Raleway"; capitalization: Font.Capitalize; pointSize: 18}

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: message.height

            states: [
                State {
                    name: "visible"
                    when: root.stage >= 1 && root.stage < 6
                    PropertyChanges {
                        target: message
                        anchors.topMargin: -5
                    }
                },
                State {
                    when: root.stage >= 5
                    PropertyChanges {
                        target: message
                        anchors.topMargin: -200;
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
