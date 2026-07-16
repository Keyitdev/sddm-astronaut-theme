// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2026 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick
import QtQuick.Controls

Item {
    id: sessionButton

    height: selectSession.height
    width: parent.width / 2

    property var selectedSession: selectSession.currentIndex
    property ComboBox exposeSession: selectSession

    ComboBox {
        id: selectSession

        height: rootHeightUnit
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter

        hoverEnabled: true
        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        Keys.onPressed: function(event) {
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened) {
                popup.open();
            }
        }

        delegate: ItemDelegate {
            // minus padding
            width: popupHandler.width - (rootScaleUnit * 20)
            anchors.horizontalCenter: popupHandler.horizontalCenter

            topPadding: rootScaleUnit * 6
            bottomPadding: rootScaleUnit * 6
            leftPadding: rootScaleUnit * 12
            rightPadding: rootScaleUnit * 12

            contentItem: Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                text: model.name
                font.pixelSize: rootFontSize * 1.06
                font.family: root.font.family
                color: config.DropdownTextColor
            }

            background: Rectangle {
                color: selectSession.highlightedIndex === index ? config.DropdownSelectedBackgroundColor : "transparent"
            }
        }

        indicator {
            visible: false
        }

        contentItem: Text {
            id: displayedItem

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: (config.TranslateSessionSelection || "Session") + " (" + selectSession.currentText + ")"
            color: config.SessionButtonTextColor
            font.pixelSize: rootFontSize * 1.06
            font.family: root.font.family

            Keys.onReleased: parent.popup.open()
        }

        background: Rectangle {
            height: parent.visualFocus ? (rootScaleUnit * 2) : 0
            width: parent.width

            color: "transparent"
        }

        popup: Popup {
            id: popupHandler

            implicitHeight: contentItem.implicitHeight
            width: sessionButton.width
            y: parent.height + rootHeightUnit
            x: 0
            padding: rootScaleUnit * 10

            contentItem: ListView {
                implicitHeight: contentHeight + (rootScaleUnit * 20)

                clip: true
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: (rootScaleUnit * config.RoundCorners) / 2
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
