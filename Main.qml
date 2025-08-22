import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Window 6.0

Window {
    width: 640
    height: 480
    visible: true
    title: "Test SDDM Qt6"

    Rectangle {
        anchors.fill: parent
        color: "green"

        Text {
            text: "Qt 6 Test - If you see this, Qt6 works"
            anchors.centerIn: parent
            color: "white"
        }
    }
}