// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2024 Keyitdev
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Button {
            id: virtualKeyboardButton
            checkable: true
            onClicked: virtualKeyboard.switchState()
           
            Keys.onReturnPressed: {
                toggle();
                virtualKeyboard.switchState();
            }
            Keys.onEnterPressed: {
                toggle();
                virtualKeyboard.switchState();
            }
            visible: virtualKeyboard.status == Loader.Ready && config.HideVirtualKeyboard == "false"
            // anchors.bottom: parent.bottom
            // anchors.bottomMargin: implicitHeight
            anchors.horizontalCenter: parent.horizontalCenter
            z: 1
            contentItem: Text {
                id: virtualKeyboardButtonText
                text: config.TranslateVirtualKeyboardButtonOff || "Virtual Keyboard (off)"
                color: parent.visualFocus ? config.HoverVirtualKeyboardButtonTextColor : config.VirtualKeyboardButtonTextColor
                font.pointSize: root.font.pointSize * 0.8
                font.family: root.font.family
            }
            background: Rectangle {
                id: virtualKeyboardButtonBackground
                color: "transparent"
            }
            states: [
                State {
                    name: "HoveredAndChecked"
                    when: virtualKeyboardButton.checked && virtualKeyboardButton.hovered
                    PropertyChanges {
                        target: virtualKeyboardButtonText
                        text: config.TranslateVirtualKeyboardButtonOn || "Virtual Keyboard (on)"
                        color: config.HoverVirtualKeyboardButtonTextColor
                    }
                },
                State {
                    name: "checked"
                    when: virtualKeyboardButton.checked
                    PropertyChanges {
                        target: virtualKeyboardButtonText
                        text: config.TranslateVirtualKeyboardButtonOn || "Virtual Keyboard (on)"
                    }
                },
                State {
                    name: "hovered"
                    when: virtualKeyboardButton.hovered
                    PropertyChanges {
                        target: virtualKeyboardButtonText
                        text: config.TranslateVirtualKeyboardButtonOff || "Virtual Keyboard (off)"
                        color: config.HoverVirtualKeyboardButtonTextColor
                    }
                }
            ]
        }

        

}