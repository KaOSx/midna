import QtQuick 2.8
import SddmComponents 2.0

Rectangle {
    id: container
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
        }

        onLoginFailed: {
            txtMessage.text = textConstants.loginFailed
            listView.currentItem.password = ""
        }

        onInformationMessage: {
            txtMessage.text = message
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
        anchors.fill: parent
        color: "transparent"
        //visible: primaryScreen

        Component {
            id: userDelegate

            PictureBox {
                anchors.verticalCenter: parent.verticalCenter
                name: (model.realName === "") ? model.name : model.realName
                icon: model.icon
                showPassword: model.needsPassword

                focus: (listView.currentIndex === index) ? true : false
                state: (listView.currentIndex === index) ? "active" : ""

                onLogin: sddm.login(model.name, password, sessionIndex);

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index;
                        listView.focus = true;
                    }
                }
            }
        }
        
        Clock {
            id: clock
            anchors.margins: 50
            anchors.top: parent.top
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left

            color: "white"
            timeFont.family: "Raleway"
        }
        
        //Rectangle {
        //    width: parent.width / 2; height: parent.height
        //    //color: "#22000000"
        //    clip: true

        //}

        Image {
            id: rectangle
            anchors.centerIn: parent
            width: Math.max(640, mainColumn.implicitWidth + 50)
            height: Math.max(500, mainColumn.implicitHeight + 50)

            source: "assets/rectangle.png"

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 12
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    verticalAlignment: Text.AlignVCenter
                    height: text.implicitHeight
                    width: parent.width
                    text: textConstants.welcomeText.arg(sddm.hostName)
                    wrapMode: Text.WordWrap
                    font.pixelSize: 24
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                Column {
                    width: parent.width
                    Item {
                        id: usersContainer
                        width: 600
                        height: 240
                        //anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter

                        ImageButton {
                            id: prevUser
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: 10
                            source: "icons/angle-down.png"
                            rotation : 90
                            onClicked: listView.decrementCurrentIndex()

                            KeyNavigation.backtab: rebootButton; KeyNavigation.tab: listView
                        }

                        ListView {
                            id: listView
                            height: parent.height
                            anchors.left: prevUser.right; anchors.right: nextUser.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: 10

                            clip: true
                            focus: true

                            spacing: 5

                            model: userModel
                            delegate: userDelegate
                            orientation: ListView.Horizontal
                            highlightRangeMode: ListView.StrictlyEnforceRange

                            //centre align selected item (which implicitly centre aligns the rest
                            preferredHighlightBegin: width/2 - 150/2
                            preferredHighlightEnd: preferredHighlightBegin

                            currentIndex: userModel.lastIndex

                            KeyNavigation.backtab: prevUser; KeyNavigation.tab: nextUser
                        }

                        ImageButton {
                            id: nextUser
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: 10
                            source: "icons/angle-down.png"
                            rotation : 270
                            onClicked: listView.incrementCurrentIndex()
                            KeyNavigation.backtab: listView; KeyNavigation.tab: session
                        }
                    }
                }
                Column {
                    width: parent.width
                    Text {
                        id: txtMessage
                        //anchors.top: usersContainer.bottom;
                        //anchors.margins: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "black"
                        text: textConstants.promptSelectUser
                        wrapMode: Text.WordWrap
                        //width:parent.width - 60
                        font.pixelSize: 12
                    }
                }
                /*Column {
                    width: parent.width
                    spacing: 4
                    Text {
                        id: lblName
                        width: parent.width
                        text: textConstants.userName
                        font.bold: true
                        font.pixelSize: 12
                    }

                    TextBox {
                        id: name
                        width: parent.width; height: 30
                        text: userModel.lastUser
                        font.pixelSize: 14

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing : 4
                    Text {
                        id: lblPassword
                        width: parent.width
                        text: textConstants.password
                        font.bold: true
                        font.pixelSize: 12
                    }

                    PasswordBox {
                        id: password
                        width: parent.width; height: 30
                        font.pixelSize: 14

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }*/

                Row {
                    spacing: 4
                    width: parent.width / 2
                    z: 100

                    Column {
                        z: 100
                        width: parent.width * 1.3
                        spacing : 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblSession
                            width: parent.width
                            text: textConstants.session
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                        }

                        ComboBox {
                            id: session
                            width: parent.width; height: 30
                            font.pixelSize: 14

                            arrowIcon: "/usr/share/sddm/themes/midna/icons/angle-down.png"

                            model: sessionModel
                            index: sessionModel.lastIndex

                            KeyNavigation.backtab: listView; KeyNavigation.tab: layoutBox
                        }
                    }

                    Column {
                        z: 101
                        width: parent.width * 0.7
                        spacing : 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblLayout
                            width: parent.width
                            text: textConstants.layout
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                        }

                        LayoutBox {
                            id: layoutBox
                            width: parent.width; height: 30
                            font.pixelSize: 14

                            arrowIcon: "/usr/share/sddm/themes/midna/icons/angle-down.png"

                            KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                        }
                    }
                }

                /*Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textConstants.prompt
                        font.pixelSize: 10
                    }
                }*/

                Row {
                    spacing: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int btnWidth: Math.max(
                                                    shutdownButton.implicitWidth,
                                                    rebootButton.implicitWidth, 120) + 8
                    /*Button {
                        id: loginButton
                        text: textConstants.login
                        width: parent.btnWidth
                        color: "#4D4D4D"

                        onClicked: sddm.login(userDelegate.name, userDelegate.password, sessionIndex)

                        KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                    }*/

                    Button {
                        id: shutdownButton
                        text: textConstants.shutdown
                        width: parent.btnWidth
                        color: "#4D4D4D"

                        onClicked: sddm.powerOff()

                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                    }

                    Button {
                        id: rebootButton
                        text: textConstants.reboot
                        width: parent.btnWidth
                        color: "#4D4D4D"

                        onClicked: sddm.reboot()

                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: prevUser
                    }
                }
            }
        }
    }

    /*Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }*/
}
