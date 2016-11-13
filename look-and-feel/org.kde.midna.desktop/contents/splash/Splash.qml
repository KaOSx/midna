/*
 *   Copyright 2014 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License version 2,
 *   or (at your option) any later version, as published by the Free
 *   Software Foundation
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.1


Image {
    id: root
    source: "images/background.png"

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true
        }
    }
    Rectangle {
        id: topRect
        width: parent.width
        height: (root.height / 3) - bottomRect.height - 2
        y: root.height
        color: "transparent"
        Image {
            source: "images/kde.svgz"
            anchors.centerIn: parent
            sourceSize.height: 128
            sourceSize.width: 128
        }
        Rectangle {
            width: parent.width
            height: 0
            color: "#646464"
        }
    }

    Rectangle {
        id: bottomRect
        width: parent.width
        y: -height
        height: 50
        color: "transparent"
        
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 0
            color: "#646464"
        }

        Rectangle {
            radius: 3
            color: "#AFB8BA"
            anchors.centerIn: parent
            height: 8
            width: height*32
            Rectangle {
                radius: 3
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: (parent.width / 6) * (stage - 1)
                color: "#414546"
                Behavior on width { 
                    PropertyAnimation {
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    SequentialAnimation {
        id: introAnimation
        running: false

        ParallelAnimation {
            PropertyAnimation {
                property: "y"
                target: topRect
                to: root.height / 4
                duration: 1000
                easing.type: Easing.InOutBack
                easing.overshoot: 2.0
            }

            PropertyAnimation {
                property: "y"
                target: bottomRect
                to: 2 * (root.height / 4) - bottomRect.height
                duration: 1000
                easing.type: Easing.InOutBack
                easing.overshoot: 1.0
            }
        }
    }
}
