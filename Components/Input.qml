// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2024 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Column {
    id: inputContainer
    Layout.fillWidth: true

    property Control exposeSession: sessionSelect.exposeSession
    property bool failed

    Item {
        // change also in selectSession
        height: root.font.pointSize * 2
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            id: errorMessage
            width: parent.width
            text: failed ? config.TranslateLoginFailedWarning || textConstants.loginFailed + "!" : keyboard.capsLock ? config.TranslateCapslockWarning || textConstants.capslockWarning : null
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: root.font.pointSize * 0.8
            font.italic: true
            color: root.palette.text
            opacity: 0
            states: [
                State {
                    name: "fail"
                    when: failed
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                },
                State {
                    name: "capslock"
                    when: keyboard.capsLock
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity"
                        duration: 100
                    }
                }
            ]
        }
    }

    Item {
        id: usernameField

        height: root.font.pointSize * 4.5
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        ComboBox {

            id: selectUser

            width: parent.height
            height: parent.height
            anchors.left: parent.left

            property var popkey: config.ForceRightToLeft == "true" ? Qt.Key_Right : Qt.Key_Left
            Keys.onPressed: {
                if (event.key == Qt.Key_Down && !popup.opened)
                    username.forceActiveFocus();
                if ((event.key == Qt.Key_Up || event.key == popkey) && !popup.opened)
                    popup.open();
                }
            KeyNavigation.down: username
            KeyNavigation.right: username
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
                    font.capitalization: Font.AllLowercase
                    color: selectUser.highlightedIndex === index ? root.palette.highlight.hslLightness >= 0.7 ? "#444" : "white" : root.palette.window.hslLightness >= 0.8 ? root.palette.highlight.hslLightness >= 0.8 ? "#444" : root.palette.highlight : "white"
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
                    width: selectUser.height * 1
                    height: parent.height
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: selectUser.height * 0
                    icon.height: parent.height * 0.25
                    icon.width: parent.height * 0.25
                    enabled: false
                    icon.color: root.palette.text
                    icon.source: Qt.resolvedUrl("../Assets/User.svg")
                    
                    background: Rectangle {
                        color: "transparent"
                        border.color: "transparent"
                    }
            }

            background: Rectangle {
                color: "transparent"
                border.color: "transparent"
            }

            popup: Popup {
                y: parent.height - username.height / 3
                x: config.ForceRightToLeft == "true" ? -loginButton.width + selectUser.width : 0
                rightMargin: config.ForceRightToLeft == "true" ? root.padding + usernameField.width / 2 : undefined
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
                    radius: config.RoundCorners / 2
                    color: root.palette.window
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 10 * config.InterfaceShadowSize
                        radius: 20 * config.InterfaceShadowSize
                        samples: 41 * config.InterfaceShadowSize
                        cached: true
                        color: Qt.hsla(0,0,0,config.InterfaceShadowOpacity)
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
                    when: selectUser.activeFocus
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
            font.bold: true
            font.capitalization: config.AllowBadUsernames == "false" ? Font.AllLowercase : Font.MixedCase
            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            placeholderText: config.TranslatePlaceholderUsername || textConstants.userName
            placeholderTextColor: config.placeholderColor
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            renderType: Text.QtRendering
            onFocusChanged:{
                if(focus)
                    selectAll()
            }
            background: Rectangle {
                color: "#222222"
                opacity: 0.2
                border.color: "transparent"
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }
            onAccepted: config.AllowBadUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: showPassword
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
                        color: root.palette.highlightedText
                    }
                }
            ]
        }
    }
    
    Item {
        id: passwordField

        height: root.font.pointSize * 4.5
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        
        Button {
            id: showPassword
            z: 2
            width: selectUser.height * 1
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: selectUser.height * 0
            icon.height: parent.height * 0.25
            icon.width: parent.height * 0.25
            icon.color: root.palette.text
            icon.source: Qt.resolvedUrl("../Assets/Password2.svg")

            background: Rectangle {
                color: "transparent"
                border.color: "transparent"
            }

            states: [
                State {
                    name: "visiblePasswordFocused"
                    when: showPassword.checked && showPassword.activeFocus
                    PropertyChanges {
                        target: showPassword
                        icon.source: Qt.resolvedUrl("../Assets/Password.svg")
                        icon.color: root.palette.highlight
                    }
                },
                State {
                    name: "visiblePasswordHovered"
                    when: showPassword.checked && showPassword.hovered
                    PropertyChanges {
                        target: showPassword
                        icon.source: Qt.resolvedUrl("../Assets/Password.svg")
                        icon.color: root.palette.highlight
                    }
                },
                State {
                    name: "visiblePassword"
                    when: showPassword.checked
                    PropertyChanges {
                        target: showPassword
                        icon.source: Qt.resolvedUrl("../Assets/Password.svg")
                    }
                },
                State {
                    name: "hiddenPasswordFocused"
                    when:  showPassword.enabled && showPassword.activeFocus
                    PropertyChanges {
                        target: showPassword
                        icon.source: Qt.resolvedUrl("../Assets/Password2.svg")
                        icon.color: root.palette.highlight
                    }
                },
                State {
                    name: "hiddenPasswordHovered"
                    when: showPassword.hovered
                    PropertyChanges {
                        target: showPassword
                        icon.source: Qt.resolvedUrl("../Assets/Password2.svg")
                        icon.color: root.palette.highlight
                    }
                }
            ]

            onClicked: toggle()
            Keys.onReturnPressed: toggle()
            Keys.onEnterPressed: toggle()
            KeyNavigation.down: password

        }

        TextField {
            id: password
            anchors.centerIn: parent
            height: root.font.pointSize * 3
            width: parent.width
            font.bold: true
            focus: config.ForcePasswordFocus == "true" ? true : false
            selectByMouse: true
            echoMode: showPassword.checked ? TextInput.Normal : TextInput.Password
            placeholderText: config.TranslatePlaceholderPassword || textConstants.password
            placeholderTextColor: config.placeholderColor
            horizontalAlignment: TextInput.AlignHCenter
            passwordCharacter: "•"
            passwordMaskDelay: config.ForceHideCompletePassword == "true" ? undefined : 1000
            renderType: Text.QtRendering
            background: Rectangle {
                color: "#222222"
                opacity: 0.2
                border.color: "transparent"
                border.width: parent.activeFocus ? 2 : 1
                radius: config.RoundCorners || 0
            }
            onAccepted: config.AllowBadUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: loginButton
        }

        states: [
            State {
                name: "focused"
                when: password.activeFocus
                PropertyChanges {
                    target: password.background
                    border.color: root.palette.highlight
                }
                PropertyChanges {
                    target: password
                    color: root.palette.highlightedText
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]        
    }

    Item {
        id: login
        // important
        height: root.font.pointSize * 9
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        visible: config.HideLoginButton == "true"  ? false : true
        Button {
            
            id: loginButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: config.TranslateLogin || textConstants.login
            height: root.font.pointSize * 3
            implicitWidth: parent.width
            enabled: config.AllowEmptyPassword == "true" || username.text != "" && password.text != "" ? true : false
            hoverEnabled: true

            contentItem: Text {
                text: parent.text
                color: config.OverrideLoginButtonTextColor != "" ? config.OverrideLoginButtonTextColor : root.palette.highlight.hslLightness >= 0.7 ? "#444" : "white"
                font.pointSize: root.font.pointSize
                font.family: root.font.family
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: 0.5
            }

            background: Rectangle {
                id: buttonBackground
                color: "white"
                opacity: 0.2
                radius: config.RoundCorners || 0
            }

            states: [
                State {
                    name: "pressed"
                    when: loginButton.down
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.darker(root.palette.highlight, 1.1)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                    }
                },
                State {
                    name: "hovered"
                    when: loginButton.hovered
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.lighter(root.palette.highlight, 1.15)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }
                },
                State {
                    name: "focused"
                    when: loginButton.activeFocus
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.lighter(root.palette.highlight, 1.2)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }
                },
                State {
                    name: "enabled"
                    when: loginButton.enabled
                    PropertyChanges {
                        target: buttonBackground;
                        color: root.palette.highlight;
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem;
                        opacity: 1
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity, color";
                        duration: 300
                    }
                }
            ]
            onClicked: config.AllowBadUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            Keys.onReturnPressed: clicked()
            Keys.onEnterPressed: clicked()
            KeyNavigation.down: sessionSelect.exposeSession
        }
    }

    SessionButton {
        id: sessionSelect
        loginButtonWidth: loginButton.background.width
    }

    Connections {
        target: sddm
        onLoginSucceeded: {}
        onLoginFailed: {
            failed = true
            resetError.running ? resetError.stop() && resetError.start() : resetError.start()
        }
    }

    Timer {
        id: resetError
        interval: 2000
        onTriggered: failed = false
        running: false
    }
}
