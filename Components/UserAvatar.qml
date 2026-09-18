// Config created by Noctua & Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM

Item {
    id: avatarBlock
    property real inputWidth: 100  // Will be overridden by parent
    width: inputWidth

    Component.onCompleted: {
        if (userPicture.enabled) {
            userPicture.source = userWrapper.items.get(userList.currentIndex).model.icon;
        }
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
    }

    Item {
        Layout.alignment: Qt.AlignHCenter
        width: inputWidth
        implicitHeight: pictureBorder.height

        Rectangle {
            id: pictureBorder
            anchors.centerIn: userPicture
            height: inputWidth / 1.5 + (border.width * 2)
            width: inputWidth / 1.5 + (border.width * 2)
            //radius: height / 2 // Circle avatar
            radius: 1 // Square avatar
            border.width: config.UserBorderWidth
            border.color: config.UserBorderColor
            color: config.UserColor
        }

        Image {
            id: userPicture
            source: ""
            height: inputWidth / 1.5
            width: inputWidth / 1.5
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectCrop
            layer.enabled: true

            Rectangle {
                anchors.fill: parent
                radius: inputWidth / 3
                visible: false
            }
        }
    }
}
