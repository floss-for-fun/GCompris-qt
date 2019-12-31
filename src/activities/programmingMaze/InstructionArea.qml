/* GCompris - InstructionArea.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *   Timothée Giet <animtim@gcompris.net> (Layout and graphics rework)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import GCompris 1.0
import "../../core"

import "programmingMaze.js" as Activity

GridView {
    id: instructionArea
    width: parent.width * 0.5
    height: parent.height * 0.17
    cellWidth: background.buttonWidth
    cellHeight: background.buttonHeight

    anchors.left: parent.left
    anchors.top: mazeModel.bottom
    anchors.topMargin: background.height * 0.4

    interactive: false
    model: instructionModel

    header: HeaderArea {
        width: instructionArea.width
        height: background.height / 11
        headerOpacity: 1
        headerText: qsTr("Choose the instructions")
    }

    property string instructionToInsert

    signal spaceKeyPressed
    signal tabKeyPressed

    onSpaceKeyPressed: {
        if(instructionArea.currentIndex != -1)
            instructionArea.currentItem.selectCurrentInstruction()
    }

    onTabKeyPressed:  {
        instructionArea.currentIndex = -1
        background.areaWithKeyboardInput = mainFunctionCodeArea
    }

    highlight: Rectangle {
        width: buttonWidth - 3 * ApplicationInfo.ratio
        height: buttonHeight * 1.18 - 3 * ApplicationInfo.ratio
        color: "#00ffffff"
        border.width: 3.5 * ApplicationInfo.ratio //activity.keyboardNavigationVisible ? 3.5 * ApplicationInfo.ratio : 0
        border.color: "#e77935"
        z: 2
        radius: width / 18
    }
    highlightFollowsCurrentItem: true
    keyNavigationWraps: true

    delegate: Item {
        id: instructionItem
        width: background.buttonWidth
        height: background.buttonHeight * 1.18

        Rectangle {
            id: imageHolder
            width: parent.width - 3 * ApplicationInfo.ratio
            height: parent.height - 3 * ApplicationInfo.ratio
            border.width: 1.2 * ApplicationInfo.ratio
            border.color: "#2a2a2a"
            anchors.centerIn: parent
            radius: width / 18
            color: instructionArea.instructionToInsert == name ? "#f3bc9a" : "#ffffff"

            Image {
                id: icon
                source: Activity.url + name + ".svg"
                width: Math.round(parent.width / 1.2)
                height: Math.round(parent.height / 1.2)
                sourceSize.width: height
                sourceSize.height: height
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: (items.isTuxMouseAreaEnabled || items.isRunCodeEnabled) && ((items.numberOfInstructionsAdded < items.maxNumberOfInstructionsAllowed) || procedureCodeArea.isEditingInstruction || mainFunctionCodeArea.isEditingInstruction)

            onPressed: instructionItem.checkModelAndInsert()
        }

        function selectCurrentInstruction() {
            if(!mainFunctionCodeArea.isEditingInstruction && !procedureCodeArea.isEditingInstruction) {
                instructionArea.instructionToInsert = name
                playClickedAnimation()
            }
            else {
                if(mainFunctionCodeArea.isEditingInstruction)
                    insertIntoModel(mainFunctionModel, mainFunctionCodeArea)
                if(procedureCodeArea.isEditingInstruction && (name != Activity.CALL_PROCEDURE))
                    insertIntoModel(procedureModel, procedureCodeArea)
            }
        }

        function checkModelAndInsert() {
            if(items.constraintInstruction.opacity)
                items.constraintInstruction.hide()

            if(!background.insertIntoMain && (name != Activity.CALL_PROCEDURE))
                insertIntoModel(procedureModel, procedureCodeArea)
            else if(background.insertIntoMain)
                insertIntoModel(mainFunctionModel, mainFunctionCodeArea)
        }

        /**
         * If we are adding an instruction, append it to the model if number of instructions added is less than the maximum number of instructions allowed.
         * If editing, replace it with the selected instruction in the code area.
         */
        function insertIntoModel(model, area) {
            if(!area.isEditingInstruction) {
                if(items.numberOfInstructionsAdded >= items.maxNumberOfInstructionsAllowed)
                    constraintInstruction.changeConstraintInstructionOpacity()
                else {
                    playClickedAnimation()
                    model.append({ "name": name })
                    items.numberOfInstructionsAdded++
                }
            }
            else {
                playClickedAnimation()
                model.set(area.initialEditItemIndex, {"name": name}, 1)
                area.resetEditingValues()
            }
        }

        /**
         * If two successive clicks on the same icon are made very fast, stop the ongoing animation and set the scale back to 1.
         * Then start the animation for next click.
         * This gives proper feedback of multiple clicks.
         */
        function playClickedAnimation() {
            clickedAnimation.stop()
            icon.scale = 1
            clickedAnimation.start()
        }

        SequentialAnimation {
            id: clickedAnimation
            PropertyAnimation {
                target: imageHolder
                property: "scale"
                to: 0.8
                duration: 150
            }

            PropertyAnimation {
                target: imageHolder
                property: "scale"
                to: 1
                duration: 150
            }
        }
    }
}
