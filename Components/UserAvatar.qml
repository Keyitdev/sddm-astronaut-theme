// Config created by Noctua & Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM

Item {
    id: avatarBlock

    property real inputWidth: 180 // Will be overridden by parent

    width: inputWidth
    height: implicitWidth
    Component.onCompleted: {
        if (userPicture.enabled)
            userPicture.source = userWrapper.items.get(userList.currentIndex).model.icon;

    }

    DelegateModel {
        id: userWrapper

        model: userModel

        delegate: ItemDelegate {
            id: userEntry
            highlighted: userList.currentIndex === index
        }

    }

    ListView {
        id: userList

        implicitHeight: contentHeight
        spacing: 8
        model: userWrapper
        currentIndex: userModel.lastIndex
        clip: true
    
        // onCurrentIndexChanged: {
            
        //     userPicture.source = userWrapper.items.get(userList.currentIndex).model.icon;
        //     userPicture.visible = true;

        // }
    }

    Rectangle {
        Layout.alignment: Qt.AlignHCenter
        width: inputWidth + 10
        height: inputWidth + 10
        implicitHeight: pictureBorder.height
        radius: 100
        color: config.FormBackgroundColor

        Image {
            id: userPicture

            source: ""
            height: inputWidth
            width: inputWidth
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        MultiEffect {
            source: userPicture
            anchors.fill: userPicture
            maskEnabled: true
            maskSource: mask
        }

        Item {
            id: mask

            width: userPicture.width
            height: userPicture.height
            layer.enabled: true
            visible: false

            Rectangle {
                width: userPicture.width
                height: userPicture.height
                radius: width / 2
                color: "black"
            }

        }

    }

}
