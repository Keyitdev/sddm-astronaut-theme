// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2026 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

RowLayout {
    spacing: rootFontSize
    property var shutdown: ["Shutdown", config.TranslateShutdown || textConstants.shutdown, sddm.canPowerOff]
    property var reboot: ["Reboot", config.TranslateReboot || textConstants.reboot, sddm.canReboot]
    property var suspend: ["Suspend", config.TranslateSuspend || textConstants.suspend, sddm.canSuspend]
    property var hibernate: ["Hibernate", config.TranslateHibernate || textConstants.hibernate, sddm.canHibernate]
    property ComboBox exposedSession

    Repeater {
        id: systemButtons
        model: [shutdown, reboot, suspend, hibernate]
        RoundButton {
            id: sysButton
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: modelData[1]
            font.pixelSize: rootFontSize * 1.06
            icon.source: modelData ? Qt.resolvedUrl("../Assets/" + modelData[0] + ".svg") : ""
            icon.height: 2 * Math.round((rootFontSize * 3) / 2)
            icon.width: 2 * Math.round((rootFontSize * 3) / 2)
            icon.color: config.SystemButtonsIconsColor
            palette.buttonText: config.SystemButtonsIconsColor
            display: AbstractButton.TextUnderIcon
            spacing: rootScaleUnit * 6
            padding: rootScaleUnit * 8
            visible: config.HideSystemButtons != "true" && (config.BypassSystemButtonsChecks == "true" ? 1 : modelData[2])
            hoverEnabled: true
            background: Rectangle {
                height: rootScaleUnit * 2
                width: parent.width
                color: "transparent"
            }
            Keys.onReturnPressed: clicked()
            onClicked: {
                parent.forceActiveFocus()
                index == 0 ? sddm.powerOff() : index == 1 ? sddm.reboot() : index == 2 ? sddm.suspend() : sddm.hibernate()
            }
            KeyNavigation.left: index > 0 ? parent.children[index-1] : null
            states: [
                State {
                    name: "pressed"
                    when: sysButton.down
                    PropertyChanges {
                        target: sysButton
                        icon.color: root.palette.buttonText
                        palette.buttonText: Qt.darker(root.palette.buttonText, 1.1)
                    }
                },
                State {
                    name: "hovered"
                    when: sysButton.hovered
                    PropertyChanges {
                        target: sysButton
                        icon.color: root.palette.buttonText
                        palette.buttonText: Qt.lighter(root.palette.buttonText, 1.1)
                    }
                },
                State {
                    name: "focused"
                    when: sysButton.activeFocus
                    PropertyChanges {
                        target: sysButton
                        icon.color: root.palette.buttonText
                        palette.buttonText: root.palette.buttonText
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "palette.buttonText, border.color"
                        duration: 150
                    }
                }
            ]
        }
    }
}
