/* Copyright 2016, Ableton AG, Berlin. All rights reserved.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  If you would like to incorporate Link into a proprietary software application,
 *  please contact <link-devs@ableton.com>.
 */

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    width: 768 / 2
    height: 576 / 2

    Rectangle {
        id: linkView
        x: 31 / 2
        y: 25 / 2
        width: 170 / 2
        height: 50 / 2
        border.color: "#404040"
        border.width: 1
        color: controller.isLinkEnabled ? "#E6E6E6" : "#FFFFFF"

        Label {
            id: linkLabel
            property var linkEnabledText: "0 Links"
            text: controller.isLinkEnabled ? linkEnabledText : "Link"
            color: "#404040"
            font.pixelSize: 36 / 2
            font.family: "Calibri"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            Connections {
                target: controller

                onNumberOfPeersChanged: {
                    linkLabel.linkEnabledText = controller.numberOfPeers + " Link"
                    linkLabel.linkEnabledText = controller.numberOfPeers == 1
                        ? linkLabel.linkEnabledText
                        : linkLabel.linkEnabledText + "s"
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            onPressed: {
                controller.isLinkEnabled = !controller.isLinkEnabled
            }
        }
    }

    Rectangle {
        id: startStopSyncView
        x: (parent.width - width - 31) / 2
        y: 25 / 2
        width: 300 / 2
        height: 50 / 2

        border.color: "#404040"
        border.width: 1 / 2
        color: controller.isStartStopSyncEnabled ? "#E6E6E6" : "#FFFFFF"

        Label {
            id: startStopSyncLabel
            text: controller.isStartStopSyncEnabled ?
                "StartStopSync On" : "StartStopSync Off"
            color: "#404040"
            font.pixelSize: 36 / 2
            font.family: "Calibri"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent

            onPressed: {
                controller.isStartStopSyncEnabled = !controller.isStartStopSyncEnabled
            }
        }
    }

    Rectangle {
        id: loopView
        x: 30 / 2
        y: 90 / 2
        width: 708 / 2
        height: 328 / 2

        function onQuantumChanged() {
            for(var i = loopView.children.length; i > 0 ; i--) {
                loopView.children[i-1].destroy()
            }

            var numSegments = Math.ceil(controller.quantum)
            for (var i = 0; i < numSegments; i++) {
                var width = loopView.width / controller.quantum
                var x = i * width
                var component = Qt.createComponent("BeatTile.qml");
                var tile = component.createObject(loopView, {
                    "index": i,
                    "x": x,
                    "width": x + width > loopView.width ? loopView.width - x : width,
                    })
                tile.activeColor = i == 0 ? "#FF6A00" : "#FFD500"
            }
        }

        Connections {
            target: controller

            onQuantumChanged: {
                loopView.onQuantumChanged()
            }
        }

        Timer {
            interval: 8 / 2
            running: true
            repeat: true
            property var last: 1
            onTriggered: {
                var index = controller.isPlaying
                    ? Math.floor(controller.beatTime() % controller.quantum)
                    : controller.quantum
                var countIn = index < 0;
                var beat = countIn ? controller.quantum + index : index
                for(var i = 0; i < loopView.children.length ; i++) {
                    loopView.children[i].countIn = countIn
                    loopView.children[i].currentBeat = beat
                }
            }
        }

        Component.onCompleted: {
            onQuantumChanged()
        }
    }

    Label {
        x: 31 / 2
        y: 460 / 2
        width: 170 / 2
        height: 30 / 2
        text: "Quantum";
        color: "#404040"
        font.pixelSize: 24 / 2
        font.family: "Calibri"
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        id: quantumView
        x: 31 / 2
        y: 500 / 2
        width: 170 / 2
        height: 50 / 2
        border.width : 1 / 2
        border.color: "#404040"

        Label {
            id: quantumLabel
            text: controller.quantum.toFixed()
            color: "#404040"
            font.pixelSize: 36 / 2
            font.family: "Calibri"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent

            property var clickQuantum: 0
            property var clickY: 0

            onPressed: {
                clickQuantum = controller.quantum
                clickY = mouseY
            }

            onPositionChanged: {
                var quantum = clickQuantum + 0.1 * (clickY - mouseY)
                controller.quantum = Math.max(1, quantum.toFixed())
            }

            onDoubleClicked: {
                controller.quantum = 4
            }
        }
    }

    Label {
        x: (parent.width - width) / 2 - 90
        y: 460 / 2
        width: 170 / 2
        height: 30 / 2
        text: "Tempo";
        color: "#404040"
        font.pixelSize: 24 / 2
        font.family: "Calibri"
        horizontalAlignment: Text.AlignHCenter
    }


    Rectangle {
        id: tempoView
        x: ((parent.width - width) / 2 - 90) / 2
        y: 500 / 2
        width: 170 / 2
        height: 50 / 2
        border.width : 1 / 2
        border.color: "#404040"

        Label {
            id: tempoLabel
            text: controller.tempo.toFixed(2)
            color: "#404040"
            font.pixelSize: 36 / 2
            font.family: "Calibri"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent

            property var clickTempo: 0
            property var clickY: 0

            onPressed: {
                clickTempo = controller.tempo
                clickY = mouseY
            }

            onPositionChanged: {
                var tempo = clickTempo + 0.5 * (clickY - mouseY)
                controller.tempo = tempo
            }

            onDoubleClicked: {
                controller.tempo = 120
            }
        }
    }

    Label {
        id: beatTimeView
        x: ((parent.width - width) / 2 + 90) / 2
        y: 460 / 2
        width: 170 / 2
        height: 30 / 2
        text: "Beats"
        color: "#404040"
        font.pixelSize: 24 / 2
        font.family: "Calibri"
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        id: beatTimeIntView
        x: ((parent.width - width) / 2 + 90) / 2
        y: 500 / 2
        width: 170 / 2
        height: 50 / 2
        border.width: 1 / 2
        border.color: "#404040"

        Label {
            id: beatTimeText
            color: "#404040"
            font.pixelSize: 36 / 2
            font.family: "Calibri"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Timer {
        id: timer
        interval: 10 / 2
        repeat: true
        running: true

        onTriggered: {
            var beatTime = controller.beatTime()
            beatTimeText.text = beatTime.toFixed(1)
            transportText.text = controller.isPlaying ? "Pause" : "Play";
            transportView.color = controller.isPlaying ? "#E6E6E6" : "#FFFFFF";
        }
    }

    Rectangle {
        id: transportView
        x: (parent.width - width - 31) / 2
        y: 500 / 2
        width: 170 / 2
        height: 50 / 2
        border.width: 1
        border.color: "#404040"

        Label {
            id: transportText
            color: "#404040"
            font.pixelSize: 36 / 2
            font.family: "Calibri"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent

            onPressed: {
                controller.isPlaying = !controller.isPlaying
            }
        }
    }

    Item {
        focus: true
        Keys.onPressed: {
            if ( event.key == 32) {
                controller.isPlaying = !controller.isPlaying
            }
        }
    }
}
