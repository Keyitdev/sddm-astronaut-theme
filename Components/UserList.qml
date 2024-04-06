// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2024 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: usernameField

    height: root.font.pointSize * 4.5
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter

    property var selectedUser: selectUser.currentIndex
    property alias user: username.text

    ComboBox {

        id: selectUser

        width: parent.height
        height: parent.height
        anchors.left: parent.left
        z: 2

        model: userModel
        currentIndex: model.lastIndex
        textRole: "name"
        hoverEnabled: true
        onActivated: {
            username.text = currentText
        }

        delegate: ItemDelegate {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text {
                text: model.name
                font.pointSize: root.font.pointSize * 0.8
                font.capitalization: Font.Capitalize
                color: selectUser.highlightedIndex === index ? "white" : root.palette.window.hslLightness >= 0.8 ? root.palette.highlight : "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            highlighted: parent.highlightedIndex === index
            background: Rectangle {
                color: selectUser.highlightedIndex === index ? root.palette.highlight : "transparent"
            }
        }

        indicator: Button {
                id: usernameIcon
                width: selectUser.height * 0.8
                height: parent.height
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: selectUser.height * 0.125
                icon.height: parent.height * 0.25
                icon.width: parent.height * 0.25
                enabled: false
                icon.color: root.palette.text
                icon.source: Qt.resolvedUrl("../Assets/User.svg")
        }

        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }

        popup: Popup {
            y: parent.height - username.height / 3
            rightMargin: config.ForceRightToLeft == "true" ? usernameField.width / 2 : undefined
            width: usernameField.width
            implicitHeight: contentItem.implicitHeight
            padding: 10

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight + 20
                model: selectUser.popup.visible ? selectUser.delegateModel : null
                currentIndex: selectUser.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: 10
                color: root.palette.window
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 100
                    samples: 201
                    cached: true
                    color: "#88000000"
                }
            }

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1 }
            }
        }

        states: [
            State {
                name: "pressed"
                when: selectUser.down
                PropertyChanges {
                    target: usernameIcon
                    icon.color: Qt.lighter(root.palette.highlight, 1.1)
                }
            },
            State {
                name: "hovered"
                when: selectUser.hovered
                PropertyChanges {
                    target: usernameIcon
                    icon.color: Qt.lighter(root.palette.highlight, 1.2)
                }
            },
            State {
                name: "focused"
                when: selectUser.visualFocus
                PropertyChanges {
                    target: usernameIcon
                    icon.color: root.palette.highlight
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color, icon.color"
                    duration: 150
                }
            }
        ]

    }

    TextField {
        id: username
        text: config.ForceLastUser == "true" ? selectUser.currentText : null
        font.capitalization: Font.Capitalize
        anchors.centerIn: parent
        height: root.font.pointSize * 3
        width: parent.width
        placeholderText: config.TranslateUsernamePlaceholder || textConstants.userName
        selectByMouse: true
        horizontalAlignment: TextInput.AlignHCenter
        renderType: Text.QtRendering
        background: Rectangle {
            color: "transparent"
            border.color: root.palette.text
            border.width: parent.activeFocus ? 2 : 1
            radius: config.RoundCorners || 0
        }
        Keys.onReturnPressed: loginButton.clicked()
        KeyNavigation.down: password
        z: 1

        states: [
            State {
                name: "focused"
                when: username.activeFocus
                PropertyChanges {
                    target: username.background
                    border.color: root.palette.highlight
                }
                PropertyChanges {
                    target: username
                    color: root.palette.highlight
                }
            }
        ]
    }

}
