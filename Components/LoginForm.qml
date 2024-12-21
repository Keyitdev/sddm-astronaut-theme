// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2024 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM

ColumnLayout {
    id: formContainer
    SDDM.TextConstants { id: textConstants }

    property int p: config.ScreenPadding == "" ? 0 : config.ScreenPadding
    property string a: config.FormPosition

    Clock {
        id: clock
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        // important
        Layout.preferredHeight: root.height / 3
        Layout.leftMargin: p != "0" ? a == "left" ? -p : a == "right" ? p : 0 : 0
    }

    Input {
        id: input
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredHeight: root.height / 10
        Layout.leftMargin: p != "0" ? a == "left" ? -p : a == "right" ? p : 0 : 0
        Layout.topMargin:  0
    }

    SystemButtons {
        id: systemButtons
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        Layout.preferredHeight: root.height / 4
        Layout.maximumHeight: root.height / 4
        Layout.leftMargin: p != "0" ? a == "left" ? -p : a == "right" ? p : 0 : 0
        exposedSession: input.exposeSession
    }
    
    SessionButton {
        id: sessionSelect
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        // Layout.preferredHeight: root.height / 16
        // Layout.maximumHeight: root.height / 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height/16
        Layout.leftMargin: p != "0" ? a == "left" ? -p : a == "right" ? p : 0 : 0
    }

}
