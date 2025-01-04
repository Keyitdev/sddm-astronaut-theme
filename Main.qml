// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import QtMultimedia

import "Components"

Pane {
    id: root

    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.ScreenWidth
    padding: config.ScreenPadding

    LayoutMirroring.enabled: config.RightToLeftLayout == "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    palette.window: config.BackgroundColor
    palette.highlight: config.HighlightBackgroundColor
    palette.highlightedText: config.HighlightTextColor
    palette.buttonText: config.HoverSystemButtonsIconsColor

    font.family: config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80) || 13
    
    focus: true

    property bool leftleft: config.HaveFormBackground == "true" &&
                            config.PartialBlur == "false" &&
                            config.FormPosition == "left" &&
                            config.BackgroundHorizontalAlignment == "left"

    property bool leftcenter: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "left" &&
                              config.BackgroundHorizontalAlignment == "center"

    property bool rightright: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "right" &&
                              config.BackgroundHorizontalAlignment == "right"

    property bool rightcenter: config.HaveFormBackground == "true" &&
                               config.PartialBlur == "false" &&
                               config.FormPosition == "right" &&
                               config.BackgroundHorizontalAlignment == "center"

    Item {
        id: sizeHelper

        height: parent.height
        width: parent.width
        anchors.fill: parent
        
        Rectangle {
            id: tintLayer

            height: parent.height
            width: parent.width
            anchors.fill: parent
            z: 1
            color: config.DimBackgroundColor
            opacity: config.DimBackground
        }

        Rectangle {
            id: formBackground

            anchors.fill: form
            anchors.centerIn: form
            z: 1

            color: config.FormBackgroundColor
            visible: config.HaveFormBackground == "true" ? true : false
            opacity: config.PartialBlur == "true" ? 0.3 : 1
        }

        LoginForm {
            id: form

            height: parent.height
            width: parent.width / 2.5
            anchors.left: config.FormPosition == "left" ? parent.left : undefined
            anchors.horizontalCenter: config.FormPosition == "center" ? parent.horizontalCenter : undefined
            anchors.right: config.FormPosition == "right" ? parent.right : undefined
            z: 1
        }

        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"

            // x * 0.4 = x / 2.5
            width: config.KeyboardSize == "" ? parent.width * 0.4 : parent.width * config.KeyboardSize
            anchors.bottom: parent.bottom
            anchors.left: config.VirtualKeyboardPosition == "left" ? parent.left : undefined;
            anchors.horizontalCenter: config.VirtualKeyboardPosition == "center" ? parent.horizontalCenter : undefined;
            anchors.right: config.VirtualKeyboardPosition == "right" ? parent.right : undefined;
            z: 1
            
            state: "hidden"
            property bool keyboardActive: item ? item.active : false

            function switchState() { state = state == "hidden" ? "visible" : "hidden"}
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - virtualKeyboard.height
                        opacity: 1
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - root.height/4
                        opacity: 0
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"
                    to: "visible"
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = true;
                                Qt.inputMethod.show();
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                },
                Transition {
                    from: "visible"
                    to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                        }
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = false;
                                Qt.inputMethod.hide();
                            }
                        }
                    }
                }
            ]
        }
        
        Image {
            id: backgroundPlaceholderImage

            z: 10
            source: config.BackgroundPlaceholder
            visible: false
        }

        AnimatedImage {
            id: backgroundImage
            
            MediaPlayer {
                id: player
                
                videoOutput: videoOutput
                autoPlay: true
                playbackRate: config.BackgroundSpeed == "" ? 1.0 : config.BackgroundSpeed
                loops: -1
                onPlayingChanged: {
                    console.log("Video started.")
                    backgroundPlaceholderImage.visible = false;
                }
            }

            VideoOutput {
                id: videoOutput
                
                fillMode: config.CropBackground == "true" ? VideoOutput.PreserveAspectCrop : VideoOutput.PreserveAspectFit
                anchors.fill: parent
            }

            height: parent.height
            width: config.HaveFormBackground == "true" && config.FormPosition != "center" && config.PartialBlur != "true" ? parent.width - formBackground.width : parent.width
            anchors.left: leftleft || leftcenter ? formBackground.right : undefined
            anchors.right: rightright || rightcenter ? formBackground.left : undefined

            horizontalAlignment: config.BackgroundHorizontalAlignment == "left" ?
                                 Image.AlignLeft :
                                 config.BackgroundHorizontalAlignment == "right" ?
                                 Image.AlignRight : Image.AlignHCenter

            verticalAlignment: config.BackgroundVerticalAlignment == "top" ?
                               Image.AlignTop :
                               config.BackgroundVerticalAlignment == "bottom" ?
                               Image.AlignBottom : Image.AlignVCenter

            speed: config.BackgroundSpeed == "" ? 1.0 : config.BackgroundSpeed
            paused: config.PauseBackground == "true" ? 1 : 0
            fillMode: config.CropBackground == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: true
            clip: true
            mipmap: true

            Component.onCompleted:{
                var fileType = config.Background.substring(config.Background.lastIndexOf(".") + 1)
                const videoFileTypes = ["avi", "mp4", "mov", "mkv", "m4v", "webm"];
                if (videoFileTypes.includes(fileType)) {
                    backgroundPlaceholderImage.visible = true;
                    player.source = Qt.resolvedUrl(config.Background)
                    player.play();
                }
                else{
                    backgroundImage.source = config.background || config.Background
                }
            }
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask

            height: parent.height
            width: form.width
            anchors.centerIn: form

            sourceItem: backgroundImage
            sourceRect: Qt.rect(x,y,width,height)
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }

        MultiEffect {
            id: blur
            
            height: parent.height

            // width: config.FullBlur == "true" ? parent.width : form.width
            // anchors.centerIn: config.FullBlur == "true" ? parent : form

            // This solves problem when FullBlur and HaveFormBackground is set to true but PartialBlur is false and FormPosition isn't center.
            width: (config.FullBlur == "true" && config.PartialBlur == "false" && config.FormPosition != "center" ) ? parent.width - formBackground.width : config.FullBlur == "true" ? parent.width : form.width 
            anchors.centerIn: config.FullBlur == "true" ? backgroundImage : form

            source: config.FullBlur == "true" ? backgroundImage : blurMask
            blurEnabled: true
            autoPaddingEnabled: false
            blur: config.Blur == "" ? 2.0 : config.Blur
            blurMax: config.BlurMax == "" ? 48 : config.BlurMax
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }
    }
}
