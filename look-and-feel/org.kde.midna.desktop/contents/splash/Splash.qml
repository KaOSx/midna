/* === This file is part of Midna - <https://kaosx.us> ===
 *
 *   SPDX-FileCopyrightText: 2017-2020 Anke Boersma <demm@kaosx.us
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Midna is Free Software: see the License-Identifier above.
 *
 */

import QtQuick 2.12
import QtQuick.Controls 2.12

Image {
    id: root
    source: "images/background.png"

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        TextMetrics {
            id: units
            text: "Plasma for KaOS"
            property int gridUnit: boundingRect.height
            property int largeSpacing: units.gridUnit
            property int smallSpacing: Math.max(2, gridUnit/4)
        }
       
        Image {
            id: logo
            property real size: units.gridUnit * 12
            anchors.centerIn: parent
            source: "images/KaOS.svgz"
            sourceSize.width: 135
            sourceSize.height: 135

            ParallelAnimation {
                running: true

                ScaleAnimator {
                    target: logo
                    from: 0
                    to: 1
                    duration: 700
                }

                SequentialAnimation {
                    loops: Animation.Infinite

                    OpacityAnimator {
                        target: logo
                        from: 0.75
                        to: 1
                        duration: 1200
                    }
                    OpacityAnimator {
                        target: logo
                        from: 1
                        to: 0.75
                        duration: 1200
                    }
                }
            }
        }

        Image {
            id: busyIndicator
            source: "images/busy.svg"
            anchors.centerIn: parent
            sourceSize.height: 200
            sourceSize.width: 200
            RotationAnimator on rotation {
                id: rotationAnimator
                from: 0
                to: 360
                duration: 2000
                loops: Animation.Infinite
            }
        }
        Label {
            text: units.text
            anchors.horizontalCenter: busyIndicator.horizontalCenter
            anchors.top: busyIndicator.bottom
            anchors.topMargin: 35
        }
    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: 1000
        easing.type: Easing.InOutQuad
    }
}
