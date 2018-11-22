import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import SddmComponents 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Pane{
    id: root

    height: config.ScreenHeight
    width: config.ScreenWidth
    padding: 0

    LayoutMirroring.enabled: true 
    LayoutMirroring.childrenInherit: true

    palette.button: "transparent"
    palette.highlight: config.ThemeColor
    palette.text: config.ThemeColor
    palette.buttonText: config.ThemeColor
    palette.window: "#575F6C"

    font.family: config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true

    Item {
        id: image
        anchors.fill: parent
    
        Image {
            source: config.background || config.Background
            anchors.fill: parent
            asynchronous: true
            cache: true
            fillMode: Image.PreserveAspectCrop
            clip: true
            mipmap: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: parent.forceActiveFocus()
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
            
        ComboBox {
            id: combo
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            width: 100
            color: "transparent"
            borderColor: "transparent"
            focusColor: "transparent"
            hoverColor: "#A4BBDA"
            
            arrowIcon: "icons/keyboard.svg"
            arrowColor: "transparent"

            model: keyboard.layouts
            index: keyboard.currentLayout

            onValueChanged: keyboard.currentLayout = id

            Connections {
                target: keyboard

                onCurrentLayoutChanged: combo.index = keyboard.currentLayout
            }

            rowDelegate: Rectangle {
                color: "transparent"

                Text {
                    anchors.centerIn: parent

                    verticalAlignment: Text.AlignVCenter

                    text: modelItem ? modelItem.modelData.shortName : "zz"
                    font.pixelSize: 14
                    color: "#dbe3f0"
                }
            }
        }
                
        LoginForm {
            Layout.minimumHeight: parent.height
            Layout.maximumWidth: parent.width / 2.5
        
        }

    }

}
