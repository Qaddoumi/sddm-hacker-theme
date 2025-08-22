import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

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