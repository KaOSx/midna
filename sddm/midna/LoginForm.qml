import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import SddmComponents 2.0 as SDDM

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

ColumnLayout {
    id: formContainer
    SDDM.TextConstants { id: textConstants }
    
    Clock {
        id: clock
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height / 4
    }

    Input {
        id: input
        Layout.alignment: Qt.AlignTop
        Layout.preferredHeight: root.height / 10
    }

    SystemButtons {
        id: systemButtons
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height / 3
        exposedLogin: input.exposeLogin
    }

}
