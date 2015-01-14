/***************************************************************************
 *   Copyright (C) 2014 by Aleix Pol Gonzalez <aleixpol@blue-systems.com>  *
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
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1 as Controls

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

MidnaBlock {
    id: root
    property string mode: "shutdown"
    property var currentAction
    property real timeout: 30
    property real remainingTime: root.timeout
    property bool canReboot
    property bool canLogout
    property bool canShutdown
    onModeChanged: remainingTime = root.timeout

    signal cancel()
    signal shutdownRequested()
    signal rebootRequested()

    Controls.Action {
        onTriggered: root.cancel()
        shortcut: "Escape"
    }

    Controls.Action {
        onTriggered: root.currentAction()
        shortcut: "Return"
    }

    onRemainingTimeChanged: {
        if(remainingTime<0)
            root.currentAction()
    }
    Timer {
        running: true
        repeat: true
        interval: 1000
        onTriggered: remainingTime--
    }

    main: ColumnLayout {
        spacing: 0
        MidnaDarkHeading {
            id: actionLabel
            Layout.alignment: Qt.AlignHCenter
        }

        Item { height: units.largeSpacing }

        Image {
            id: actionIcon
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            fillMode: Image.PreserveAspectFit
            opacity: actionIconMouse.containsMouse ? 1 : 0.7
            MouseArea {
                id: actionIconMouse
                hoverEnabled: true
                anchors.fill: parent
                onClicked: root.currentAction();
            }
        }

        PlasmaComponents.ProgressBar {
            id: progressBar
            Layout.alignment: Qt.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter

            //wanted to use actionIcon.paintedWidth but it doesn't work well when the image changes
            width: units.largeSpacing*7
            minimumValue: 0
            maximumValue: root.timeout
            value: root.remainingTime
        }

        MidnaDarkLabel {
            anchors.right: progressBar.right
            text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","In %1 seconds", root.remainingTime);
        }

        state: mode
        states: [
            State {
                name: "shutdown"
                PropertyChanges { target: root; currentAction: shutdownRequested }
                PropertyChanges { target: actionLabel; text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Shutting down") }
                PropertyChanges { target: actionIcon; source: "artwork/shutdown_primary.svgz" }
            },
            State {
                name: "logout"
                PropertyChanges { target: root; currentAction: logoutRequested }
                PropertyChanges { target: actionLabel; text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Logging out") }
                PropertyChanges { target: actionIcon; source: "artwork/logout_primary.svgz" }
            },
            State {
                name: "reboot"
                PropertyChanges { target: root; currentAction: rebootRequested }
                PropertyChanges { target: actionLabel; text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Rebooting") }
                PropertyChanges { target: actionIcon; source: "artwork/restart_primary.svgz" }
            }
        ]
    }

    controls: Item {
        Layout.fillWidth: true
        height: buttons.height

        RowLayout {
            id: buttons
            anchors.centerIn: parent

            PlasmaComponents.Button {
                text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Cancel")
                onClicked: root.cancel()
            }

            PlasmaComponents.Button {
                id: commitButton
                onClicked: root.currentAction()
                focus: true
            }
        }

        LogoutOptions {
            id: logoutOptions
            anchors.right: parent.right
            anchors.rightMargin: 5
            canReboot: root.canReboot
            canLogout: root.canLogout
            canShutdown: root.canShutdown
            onModeChanged: root.mode = mode

            exclusive: true
            Component.onCompleted: mode = root.mode;
        }

        state: mode
        states: [
            State {
                name: "shutdown"
                PropertyChanges { target: commitButton; text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Shut down") }
            },
            State {
                name: "logout"
                PropertyChanges { target: commitButton; text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Log out") }
            },
            State {
                name: "reboot"
                PropertyChanges { target: commitButton; text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Reboot") }
            }
        ]
    }
}
