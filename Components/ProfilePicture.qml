import QtQuick
import QtQuick.Effects

Item {
    id: profilePicture

    property url userIcon: input.currentUserIcon
    property bool hasCustomIcon: userIcon != ""

    Rectangle {
        anchors.fill: avatarImage
        radius: width / 2
        color: config.LoginFieldBackgroundColor || "#000000"
        opacity: 0.2
        z: -1
    }

    Image {
        id: avatarImage

        anchors.fill: parent
        anchors.margins: ringBorder.border.width
        source: hasCustomIcon ? profilePicture.userIcon : Qt.resolvedUrl("../Assets/User.svg")
        fillMode: hasCustomIcon ? Image.PreserveAspectCrop : Image.PreserveAspectFit
        smooth: true
        mipmap: true
        asynchronous: true
        visible: false

    }

    Rectangle {
        id: circleMask

        anchors.fill: avatarImage
        radius: width / 2
        visible: false
        layer.enabled: true
    }

    MultiEffect {
        anchors.fill: avatarImage
        source: avatarImage
        maskEnabled: true
        maskSource: circleMask
    }

    Rectangle {
        id: ringBorder

        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.width: 3
        border.color: config.DateTextColor || "#ffffff"
    }
}
