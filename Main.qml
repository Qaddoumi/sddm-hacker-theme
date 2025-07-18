import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "matrix.js" as Matrix

Rectangle {
    id: root
    width: Qt.application.primaryScreen.width
    height: Qt.application.primaryScreen.height
    color: "#0a0a0a"

    // SDDM Context Properties
    property int sessionIndex: sessionSelector.currentIndex
    property alias userName: usernameField.text
    property alias password: passwordField.text

    // Background image
    Image {
        id: background
        source: "assets/background.jpg"
        anchors.fill: parent
        opacity: 0.3
        fillMode: Image.PreserveAspectCrop
    }

    // Matrix digital rain effect
    Canvas {
        id: matrixCanvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            Matrix.matrix.drawMatrix(ctx, width, height);
        }
        Timer {
            interval: 50
            running: true
            repeat: true
            onTriggered: matrixCanvas.requestPaint()
        }
    }

    // Login form
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "HACKER LOGIN"
            font.family: "JetBrainsMono Nerd Font Propo"
            font.pixelSize: 36
            color: "#00ff00"
            style: Text.Outline
            styleColor: "#00cc00"
            Layout.alignment: Qt.AlignHCenter
        }

        TextField {
            id: usernameField
            placeholderText: "Username"
            font.family: "JetBrainsMono Nerd Font Propo"
            font.pixelSize: 18
            color: "#00ff00"
            background: Rectangle {
                color: "#1a1a1a"
                border.color: "#00ff00"
                border.width: 1
                radius: 5
            }
            Layout.preferredWidth: 300
            KeyNavigation.tab: passwordField
            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    passwordField.forceActiveFocus()
                }
            }
        }

        TextField {
            id: passwordField
            placeholderText: "Password"
            echoMode: TextInput.Password
            font.family: "JetBrainsMono Nerd Font Propo"
            font.pixelSize: 18
            color: "#00ff00"
            background: Rectangle {
                color: "#1a1a1a"
                border.color: "#00ff00"
                border.width: 1
                radius: 5
            }
            Layout.preferredWidth: 300
            KeyNavigation.tab: loginButton
            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    loginButton.clicked()
                }
            }
        }

        Button {
            id: loginButton
            text: "Login"
            font.family: "JetBrainsMono Nerd Font Propo"
            font.pixelSize: 18
            background: Rectangle {
                color: parent.pressed ? "#003300" : "#1a1a1a"
                border.color: "#00ff00"
                border.width: 1
                radius: 5
            }
            contentItem: Text {
                text: "Login"
                color: "#00ff00"
                font.family: "JetBrainsMono Nerd Font Propo"
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 150
            KeyNavigation.tab: usernameField
            onClicked: {
                sddm.login(usernameField.text, passwordField.text, sessionIndex)
            }
        }
    }

    // Glitch effect
    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            root.opacity = Math.random() > 0.1 ? 1.0 : 0.8
        }
    }

    // Session selection
    ComboBox {
        id: sessionSelector
        model: sessionModel
        textRole: "name"
        font.family: "JetBrainsMono Nerd Font Propo"
        font.pixelSize: 14
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        width: 200

        background: Rectangle {
            color: "#1a1a1a"
            border.color: "#00ff00"
            border.width: 1
            radius: 5
        }
        
        contentItem: Text {
            text: sessionSelector.displayText
            color: "#00ff00"
            font.family: "JetBrainsMono Nerd Font Propo"
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
            leftPadding: 10
        }
        
        popup: Popup {
            y: sessionSelector.height
            width: sessionSelector.width
            implicitHeight: contentItem.implicitHeight
            padding: 1
            
            background: Rectangle {
                color: "#1a1a1a"
                border.color: "#00ff00"
                border.width: 1
                radius: 5
            }
            
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: sessionSelector.popup.visible ? sessionSelector.delegateModel : null
                currentIndex: sessionSelector.highlightedIndex
                
                delegate: ItemDelegate {
                    width: sessionSelector.width
                    contentItem: Text {
                        text: model.name
                        color: "#00ff00"
                        font.family: "JetBrainsMono Nerd Font Propo"
                        font.pixelSize: 14
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: highlighted ? "#003300" : "#1a1a1a"
                    }
                }
            }
        }
    }

    // Power options (optional)
    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 20
        spacing: 10

        Button {
            text: "⏻"
            font.pixelSize: 20
            width: 40
            height: 40
            background: Rectangle {
                color: "#1a1a1a"
                border.color: "#00ff00"
                border.width: 1
                radius: 5
            }
            contentItem: Text {
                text: "⏻"
                color: "#00ff00"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: sddm.powerOff()
        }

        Button {
            text: "↻"
            font.pixelSize: 20
            width: 40
            height: 40
            background: Rectangle {
                color: "#1a1a1a"
                border.color: "#00ff00"
                border.width: 1
                radius: 5
            }
            contentItem: Text {
                text: "↻"
                color: "#00ff00"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: sddm.reboot()
        }
    }

    // Error message display
    Text {
        id: errorMessage
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        color: "#ff0000"
        font.family: "JetBrainsMono Nerd Font Propo"
        font.pixelSize: 16
        visible: text.length > 0
        text: ""
    }

    // Connect to SDDM signals
    Connections {
        target: sddm
        function onLoginSucceeded() {
            errorMessage.text = ""
        }
        function onLoginFailed() {
            errorMessage.text = "Login failed. Please try again."
            passwordField.clear()
            passwordField.forceActiveFocus()
        }
    }

    Component.onCompleted: {
        if (userName.length === 0) {
            usernameField.forceActiveFocus()
        } else {
            passwordField.forceActiveFocus()
        }
    }
}