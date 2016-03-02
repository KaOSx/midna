/********************************************************************
Copyright (C) 2015 Demitrius Belai <demitriusbelai@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/
import QtQuick 2.0
import org.kde.kwin.decoration 0.1

Item {
    id: button
    property string image: ""
    property string imageHover: ""
    property string imageDisable: ""
    property string buttonType: ""
    Rectangle {
        id: rectButton
        color: "#3665b3"
        anchors.fill: parent
        opacity: 0
        state: "normal"
        states: [State {
            name: "normal";
            PropertyChanges { target: rectButton; opacity: 0 }
          },
          State {
            name: "hover";
            PropertyChanges { target: rectButton; opacity: 0 }
          }]
        transitions: [
          Transition {
              from: "hover"; to: "normal"
              PropertyAnimation { properties: "opacity"; duration: 500 }
          }]
    }
    Image {
        id: iconButton
        anchors.centerIn: parent
        source: decbutton.enabled ? button.image : button.imageDisable
        width: parent.height / 1
        height: parent.height / 1
        sourceSize.width: width
        sourceSize.height: height
        smooth: false
    }
    DecorationButton {
        id: decbutton
        function colorize() {
            rectButton.state = decbutton.hovered ? 'hover' : 'normal';
            iconButton.source = decbutton.hovered ? button.imageHover : button.image;
            console.info(iconButton.sourceSize.width, iconButton.sourceSize.height, iconButton.width, iconButton.height);
            console.info(button.width, button.height);
        }
        buttonType: button.buttonType;
        anchors.fill: parent
        onHoveredChanged: colorize()
    }
}
