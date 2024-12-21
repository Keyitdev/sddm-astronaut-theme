// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2024 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: sessionButton
    height: root.font.pointSize
    width: parent.width / 2
    // anchors.horizontalCenter: parent.horizontalCenter
    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property ComboBox exposeSession: selectSession

    ComboBox {
        id: selectSession
        // important
        // change also in errorMessage
        height: root.font.pointSize * 2
        hoverEnabled: true
        anchors.horizontalCenter: parent.horizontalCenter
        Keys.onPressed: function(event) {
        if (event.key == Qt.Key_Up && loginButton.state != "enabled" && !popup.opened) {
            revealSecret.focus = true;
            revealSecret.state = "focused";
            currentIndex = currentIndex + 1;
        }
        if (event.key == Qt.Key_Up && loginButton.state == "enabled" && !popup.opened) {
            loginButton.focus = true;
            loginButton.state = "focused";
            currentIndex = currentIndex + 1;
        }
        if (event.key == Qt.Key_Down && !popup.opened) {
            systemButtons.children[0].focus = true;
            systemButtons.children[0].state = "focused";
            currentIndex = currentIndex - 1;
        }
        if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened) {
            popup.open();
        }
        }

        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        delegate: ItemDelegate {
            // minus padding
            width: popupHandler.width - 20
            anchors.horizontalCenter: popupHandler.horizontalCenter
            contentItem: Text {
                text: model.name
                font.pointSize: root.font.pointSize * 0.8
                font.family: root.font.family
                color: config.DropdownTextColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            // highlighted: parent.highlightedIndex === index
            background: Rectangle {
                color: selectSession.highlightedIndex === index ? config.DropdownSelectedBackgroundColor : "transparent"
            }
        }

        indicator {
            visible: false
        }

        contentItem: Text {
            id: displayedItem
            text: (config.TranslateSessionSelection || "Session") + " (" + selectSession.currentText + ")"
            color: config.SessionButtonTextColor
            verticalAlignment: Text.AlignVCenter
            font.pointSize: root.font.pointSize * 0.8
            font.family: root.font.family
            Keys.onReleased: parent.popup.open()
        }

        background: Rectangle {
            color: "transparent"
            height: parent.visualFocus ? 2 : 0
            width: displayedItem.implicitWidth
            // anchors.top: parent.bottom
            // anchors.left: parent.left
            // anchors.leftMargin: 3
        }

        popup: Popup {
            id: popupHandler
            width: sessionButton.width
            y: parent.height - 1
            x:  -popupHandler.width/2 + displayedItem.width/2
            implicitHeight: contentItem.implicitHeight
            padding: 10

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight + 20
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: config.RoundCorners / 2
                color: config.DropdownBackgroundColor
                layer.enabled: true
            }

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1 }
            }
        }

        states: [
            State {
                name: "pressed"
                when: selectSession.down
                PropertyChanges {
                    target: displayedItem
                    color: Qt.darker(config.HoverSessionButtonTextColor, 1.1)
                }
            },
            State {
                name: "hovered"
                when: selectSession.hovered
                PropertyChanges {
                    target: displayedItem
                    color: Qt.lighter(config.HoverSessionButtonTextColor, 1.1)
                }
            },
            State {
                name: "focused"
                when: selectSession.visualFocus
                PropertyChanges {
                    target: displayedItem
                    color: config.HoverSessionButtonTextColor
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color"
                    duration: 150
                }
            }
        ]

    }

}
