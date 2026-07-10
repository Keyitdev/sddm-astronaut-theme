import QtQuick
import QtQuick.Effects

Item {
    id: profilePicture

    property url userIcon: input.currentUserIcon
    property bool hasCustomIcon: userIcon != ""

    Rectangle {
        anchors.fill: avatarImage
        radius: width / 2
        color: config.ProfilePictureBorderColor
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
        radius: config.ProfilePictureRoundedCorners || 0
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
        radius: config.ProfilePictureRoundedCorners || 0
        color: "transparent"
        border.width: config.ProfilePictureBorderWidth || 2
        border.color: config.ProfilePictureBorderColor
    }
}
