import QtQuick 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

TextField {
    placeholderTextColor: config.color
    palette.text: config.color
    font.pointSize: config.fontSize
    font.family: config.font
    echoMode: TextInput.Password
    inputMethodHints: Qt.ImhHiddenText | Qt.ImhSensitiveData | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
    //enabled: !authenticator.graceLocked
    //revealPasswordButtonShown: true
    passwordMaskDelay: 300
    background: Rectangle {
        color: "#808080"
        opacity: 0.7
        width: parent.width
        height: width / 9
        border.width: 1
        border.color: "#3498db"
        anchors.centerIn: parent
    }
}
