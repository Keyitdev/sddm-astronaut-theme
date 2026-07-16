// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2026 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    spacing: rootFontSize
    property var shutdown: ["Shutdown", config.TranslateShutdown || textConstants.shutdown, sddm.canPowerOff]
    property var reboot: ["Reboot", config.TranslateReboot || textConstants.reboot, sddm.canReboot]
    property var suspend: ["Suspend", config.TranslateSuspend || textConstants.suspend, sddm.canSuspend]
    property var hibernate: ["Hibernate", config.TranslateHibernate || textConstants.hibernate, sddm.canHibernate]

    Repeater {
        id: systemButtons
        model: [shutdown, reboot, suspend, hibernate]
        RoundButton {
            id: sysButton
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: modelData[1]
            font.pixelSize: rootFontSize * 1.06
            icon.source: Qt.resolvedUrl("../Assets/" + modelData[0] + ".svg")
            icon.height: 2 * Math.round((rootFontSize * 3) / 2)
            icon.width: 2 * Math.round((rootFontSize * 3) / 2)
            icon.color: config.SystemButtonsIconsColor
            palette.buttonText: config.SystemButtonsIconsColor
            display: AbstractButton.TextUnderIcon
            spacing: rootScaleUnit * 6
            padding: rootScaleUnit * 8
            visible: config.ShowSystemButtons == "true" && (config.BypassSystemButtonsChecks == "true" || modelData[2])
            hoverEnabled: true
            background: Rectangle {
                height: rootScaleUnit * 2
                width: parent.width
                color: "transparent"
            }
            Keys.onReturnPressed: clicked()
            onClicked: {
                parent.forceActiveFocus()
                switch (index) {
                case 0: sddm.powerOff(); break
                case 1: sddm.reboot(); break
                case 2: sddm.suspend(); break
                default: sddm.hibernate()
                }
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
