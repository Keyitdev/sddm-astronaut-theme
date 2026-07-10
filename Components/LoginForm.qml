// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
import QtQuick 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM
Item {
    id: formContainer
    SDDM.TextConstants { id: textConstants }

    readonly property real clockTopMargin: (Number(config.ClockTopMargin) || 0) * rootHeightUnit
    readonly property real profilePictureTopMargin: (Number(config.ProfilePictureTopMargin) || 0) * rootHeightUnit
    readonly property real loginInputTopMargin: (Number(config.LoginInputTopMargin) || 0) * rootHeightUnit
    readonly property real systemButtonsBottomMargin: (Number(config.SystemButtonsBottomMargin) || 0) * rootHeightUnit
    readonly property real sessionSelectBottomMargin: (Number(config.SessionSelectBottomMargin) || 0) * rootHeightUnit
    readonly property real virtualKeyboardButtonBottomMargin: (Number(config.VirtualKeyboardButtonBottomMargin) || 0) * rootHeightUnit

    ColumnLayout {
        id: topGroup
        spacing: 0
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: clockBox
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: clockTopMargin
            Layout.preferredHeight: clock.implicitHeight + (rootHeightUnit * 1.5)
            implicitWidth: clock.implicitWidth + (rootWidthUnit * 3)
            radius: 20
            Layout.preferredWidth: implicitWidth
            Clock {
                anchors.fill: parent
                id: clock
                Layout.alignment: Qt.AlignHCenter
            }
        }
        Rectangle {
            id: profilePictureBox
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: profilePictureTopMargin
            Layout.preferredHeight: profilePicture.height
            implicitWidth: profilePicture.width + (rootWidthUnit * 3)
            Layout.preferredWidth: implicitWidth
            ProfilePicture {
                id: profilePicture
                visible: config.ShowProfilePicture == "true" ? true : false
                anchors.centerIn: parent
                width: rootHeightUnit * 11
                height: rootHeightUnit * 11
            }
        }
        Rectangle {
            id: inputBox
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: loginInputTopMargin
            Layout.preferredHeight: input.implicitHeight
            implicitWidth: input.implicitWidth
            Layout.preferredWidth: implicitWidth
            Input {
                id: input
                anchors.centerIn: parent
                width: rootWidthUnit * 65
            }
        }
    }

    ColumnLayout {
        id: bottomGroup
        spacing: 0
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: systemButtonsBox
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: systemButtonsBottomMargin
            Layout.preferredHeight: systemButtons.implicitHeight
            implicitWidth: systemButtons.implicitWidth
            Layout.preferredWidth: implicitWidth
            SystemButtons {
                id: systemButtons
                exposedSession: input.exposeSession
                anchors.centerIn: parent
            }
        }
        Rectangle {
            id: sessionSelectBox
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: sessionSelectBottomMargin
            Layout.preferredHeight: sessionSelect.height
            implicitWidth: sessionSelect.width
            Layout.preferredWidth: implicitWidth
            SessionButton {
                id: sessionSelect
                anchors.centerIn: parent
                width: rootWidthUnit * 32.5
            }
        }
        Rectangle {
            id: virtualKeyboardButtonBox
            color: "transparent"
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: virtualKeyboardButtonBottomMargin
            Layout.preferredHeight: virtualKeyboardButton.height
            implicitWidth: virtualKeyboardButton.width
            Layout.preferredWidth: implicitWidth
            VirtualKeyboardButton {
                id: virtualKeyboardButton
                anchors.centerIn: parent
                width: rootWidthUnit * 32.5
            }
        }
    }
}
