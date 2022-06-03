/*
    SPDX-FileCopyrightText: 2017 Martin Gräßlin <mgraesslin@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.VirtualKeyboard 2.4

import org.kde.plasma.core 2.0 as PlasmaCore

InputPanel {
    id: inputPanel
    property bool activated: false
    active: activated && Qt.inputMethod.visible
    width: parent.width / 3

    states: [
        State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: inputPanel.parent.height - inputPanel.height
                x: inputPanel.parent.width - inputPanel.width
                opacity: 1
                visible: true
            }
        },
        State {
            name: "hidden"
            when: !inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: inputPanel.parent.height
                x: inputPanel.parent.width - inputPanel.width
                opacity: 0
                visible:false
            }
        }
    ]

    transitions: [
        Transition {
            to: "visible"
            ParallelAnimation {
                YAnimator {
                    // NOTE this is necessary as otherwise the keyboard always starts the transition with Y as 0, due to the internal reparenting happening when becomes active
                    from: inputPanel.parent.height
                    duration: PlasmaCore.Units.longDuration
                    easing.type: Easing.OutQuad
                }
                OpacityAnimator {
                    duration: PlasmaCore.Units.longDuration
                    easing.type: Easing.OutQuad
                }
            }
        },
        Transition {
            to: "hidden"
            ParallelAnimation {
                YAnimator {
                    duration: PlasmaCore.Units.longDuration
                    easing.type: Easing.InQuad
                }
                OpacityAnimator {
                    duration: PlasmaCore.Units.longDuration
                    easing.type: Easing.InQuad
                }
            }
        }
    ]
}
