import QtQuick 6.0
import SddmComponents 2.0

Rectangle {
    width: 1920
    height: 1080
    color: "#1a1a1a"

    property int sessionIndex: session.index

    Rectangle {
        id: loginBox
        anchors.centerIn: parent
        width: 400
        height: 300
        color: "#2a2a2a"
        radius: 8

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Login"
                color: "#ffffff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 300
                height: 40
                color: "#3a3a3a"
                radius: 4

                TextInput {
                    id: name
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    verticalAlignment: TextInput.AlignVCenter
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    selectByMouse: true
                    focus: true

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return) {
                            password.focus = true
                        }
                    }
                }

                Text {
                    text: "Username"
                    color: "#888888"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    visible: name.text.length === 0
                }
            }

            Rectangle {
                width: 300
                height: 40
                color: "#3a3a3a"
                radius: 4

                TextInput {
                    id: password
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    verticalAlignment: TextInput.AlignVCenter
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    echoMode: TextInput.Password
                    selectByMouse: true

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return) {
                            sddm.login(name.text, password.text, sessionIndex)
                        }
                    }
                }

                Text {
                    text: "Password"
                    color: "#888888"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    visible: password.text.length === 0
                }
            }

            Rectangle {
                width: 300
                height: 40
                color: loginMouseArea.pressed ? "#4a4a4a" : "#5a5a5a"
                radius: 4

                Text {
                    text: "Login"
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: loginMouseArea
                    anchors.fill: parent
                    onClicked: {
                        sddm.login(name.text, password.text, sessionIndex)
                    }
                }
            }
        }
    }

    // Power button
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        width: 40
        height: 30
        color: powerMouseArea.pressed ? "#4a4a4a" : "#2a2a2a"
        radius: 4

        Text {
            text: "⏻"
            color: "#ffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
            anchors.centerIn: parent
        }

        MouseArea {
            id: powerMouseArea
            anchors.fill: parent
            onClicked: {
                sddm.powerOff()
            }
        }
    }

    // Session info
    Text {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 20
        text: session.name
        color: "#888888"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 12
    }

    Connections {
        target: sddm
        onLoginFailed: {
            password.text = ""
            password.focus = true
        }
    }
}