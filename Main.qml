import QtQuick 6.0
import QtQuick.Controls 6.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#1a1a1a"

    property int sessionIndex: session.index

    // Background
    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"
    }

    // Main container
    Rectangle {
        id: mainContainer
        anchors.centerIn: parent
        width: 400
        height: 300
        color: "#2a2a2a"
        radius: 8
        border.color: "#3a3a3a"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 20

            // Title
            Text {
                text: "Login"
                color: "#ffffff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24
                font.weight: Font.Bold
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Username field
            TextField {
                id: usernameField
                width: 300
                height: 40
                placeholderText: "Username"
                placeholderTextColor: "#888888"
                color: "#ffffff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                background: Rectangle {
                    color: "#3a3a3a"
                    border.color: "#555555"
                    border.width: 1
                    radius: 4
                }
                selectByMouse: true
                focus: true
                
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        passwordField.focus = true
                    }
                }
            }

            // Password field
            TextField {
                id: passwordField
                width: 300
                height: 40
                placeholderText: "Password"
                placeholderTextColor: "#888888"
                color: "#ffffff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                echoMode: TextInput.Password
                background: Rectangle {
                    color: "#3a3a3a"
                    border.color: "#555555"
                    border.width: 1
                    radius: 4
                }
                selectByMouse: true
                
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        loginButton.clicked()
                    }
                }
            }

            // Login button
            Button {
                id: loginButton
                width: 300
                height: 40
                text: "Login"
                
                background: Rectangle {
                    color: loginButton.pressed ? "#4a4a4a" : "#5a5a5a"
                    border.color: "#6a6a6a"
                    border.width: 1
                    radius: 4
                }
                
                contentItem: Text {
                    text: loginButton.text
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: function() {
                    sddm.login(usernameField.text, passwordField.text, sessionIndex)
                }
            }
        }
    }

    // Session selector (bottom right)
    ComboBox {
        id: sessionComboBox
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        width: 200
        height: 30
        
        model: sessionModel
        currentIndex: sessionModel.lastIndex
        textRole: "name"
        
        background: Rectangle {
            color: "#2a2a2a"
            border.color: "#3a3a3a"
            border.width: 1
            radius: 4
        }
        
        contentItem: Text {
            text: sessionComboBox.displayText
            color: "#ffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            leftPadding: 8
        }
        
        onCurrentIndexChanged: {
            sessionIndex = currentIndex
        }
    }

    // Power buttons (bottom left)
    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 20
        spacing: 10

        Button {
            width: 40
            height: 30
            text: "⏻"
            
            background: Rectangle {
                color: parent.pressed ? "#4a4a4a" : "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 1
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                color: "#ffffff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: function() { sddm.powerOff() }
        }

        Button {
            width: 40
            height: 30
            text: "↻"
            
            background: Rectangle {
                color: parent.pressed ? "#4a4a4a" : "#2a2a2a"
                border.color: "#3a3a3a"
                border.width: 1
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                color: "#ffffff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: function() { sddm.reboot() }
        }
    }

    // Connect to SDDM
    Connections {
        target: sddm
        function onLoginSucceeded() {
            // Login successful
        }
        function onLoginFailed() {
            passwordField.clear()
            passwordField.focus = true
        }
    }
}