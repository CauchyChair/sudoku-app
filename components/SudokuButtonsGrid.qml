import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Repeater {

    id: buttonsGrid;
    model: 81
    objectName: "buttonsGrid";
    //x : 3* -mainView.blockDistance

    function redrawGrid()
    {
        //console.log("on redraw grid")
        for(var i=0; i < model; i++)
        {
            var row = Math.floor(i/9);
            var column = i%9;


            if(buttonsGrid.itemAt(i).enabled)
            {
                var testField = grid.cellConflicts(column,row)
                //print (testField)

                if (testField == true)
                {
                    //console.log("index "+i+" row/col "+row+"/"+column)
                    buttonsGrid.itemAt(i).buttonColor = defaultNotAllowedColor;
                    buttonsGrid.itemAt(i).textColor = defaultTextColor;
                }
                else {
                    if(buttonsGrid.itemAt(i).hinted)
                    {
                        //buttonsGrid.itemAt(i).buttonColor = defaultHintColor;
                        buttonsGrid.itemAt(i).textColor = defaultHintColor;
                    }else{
                        buttonsGrid.itemAt(i).buttonColor = defaultColor;
                        buttonsGrid.itemAt(i).textColor = textColor;
                        buttonsGrid.itemAt(currentX).boldText = false;
                    }
                }
            }
        }
    }



    SudokuButton {
        id: gridButton;

        property bool hinted : false

        buttonText: "0";
        //width: units.gu(5);
        //height: units.gu(5);
        size: mainView.width/mainView.height < mainView.resizeFactor ?
                  mainView.width/10: units.gu(50)/10;
        //color: defaultColor;
        //border.width: 0
        //border.color: defaultBorderColor
        //textColor: defaultTextColor;
        UbuntuNumberAnimation {
            id: numbersAnimation
            target: gridButton; property: "opacity";
            duration: 2000; easing.type: Easing.InOutQuad
            from: 0; to: 1
            running: true;
            loops: 1
        }

        anchors.left:  ((index - (Math.floor(index / 9) * 9)) > 0) ? buttonsGrid.itemAt(index-1).right : buttonsGrid.left//((index - (Math.floor(index / 9) * 9)) > 0) ? buttonsGrid.itemAt(index-1).right : mainView.left
        anchors.leftMargin:   ((index - (Math.floor(index / 9) * 9))%3 == 0) ? 4*mainView.blockDistance : mainView.blockDistance

        anchors.top: (Math.floor(index / 9) > 0) ? buttonsGrid.itemAt(index-9).bottom : buttonsGrid.top //(Math.floor(index / 9) > 0) ? buttonsGrid.itemAt(index-9).bottom : mainView.top
        anchors.topMargin: (Math.floor(index / 9)%3 == 0) ? 4*mainView.blockDistance : mainView.blockDistance
        MouseArea {
            id: buttonMouseArea2
            anchors.fill: parent
            enabled: !gridButton.hinted
            SequentialAnimation {
                id: animateButton
                UbuntuNumberAnimation {
                    id: animateButton1
                    target: gridButton
                    properties: "scale"
                    to: 1.05
                    from: 1
                    duration: UbuntuAnimation.SnapDuration
                    easing: UbuntuAnimation.StandardEasing
                }
                UbuntuNumberAnimation {
                    id: animateButton2
                    target: gridButton
                    properties: "scale"
                    to: 1
                    from: 1.05
                    duration: UbuntuAnimation.SnapDuration
                    easing: UbuntuAnimation.StandardEasing
                }
                onRunningChanged: {
                    if (animateButton.running == false ) {
                        mainRectangle.currentX = index;
                        var currentLeft = buttonsGrid.itemAt(mainRectangle.currentX).x
                        var currentTop = buttonsGrid.itemAt(mainRectangle.currentX).y
                        var LeftDelta = (buttonsGrid.itemAt(1).x-buttonsGrid.itemAt(0).x)/2
                        var TopDelta = (buttonsGrid.itemAt(9).y-buttonsGrid.itemAt(0).y)/2
                        gridButton.buttonColor = defaultColor;
                        //dialogue.visible = true
                        var middleX = currentLeft + LeftDelta
                        var middleY = currentTop + TopDelta
                        dialogue.popup(middleX, middleY)

                    }

                }
            }

            onClicked: {
                //animateButton.start();
                /*mainRectangle.currentX = index;
                gridButton.buttonColor = defaultColor;*/
                //dialogue.visible= true//PopupUtils.open(dialogue, gridButton)*/
                //dialogue.popup(buttonsGrid.itemAt(currentX).x, buttonsGrid.itemAt(currentX).y)
            }
            onPressed: {
                gridButton.buttonColor = String(Qt.darker(defaultColor,1.05));
                animateButton.start();
            }

            onCanceled: {
                gridButton.buttonColor = defaultColor
            }

            onExited: {
                gridButton.buttonColor = defaultColor
            }
        }
        buttonColor: defaultColor;
        textColor: defaultTextColor
    }

    Component.onCompleted: {
        switch(settingsTab.difficultyIndex) {
        case 0:
            var randomnumber = Math.floor(Math.random()*9);
            randomnumber += 31;
            sudokuBlocksGrid.createNewGame(81 - randomnumber);
            break;
        case 1:
            var randomnumber = Math.floor(Math.random()*4);
            randomnumber += 26;
            sudokuBlocksGrid.createNewGame(81 - randomnumber);
            break;
        case 2:
            var randomnumber = Math.floor(Math.random()*4);
            randomnumber += 21;
            sudokuBlocksGrid.createNewGame(81 - randomnumber);
            break;
        case 3:
            var randomnumber = Math.floor(Math.random()*3);
            randomnumber += 17;
            sudokuBlocksGrid.createNewGame(81 - randomnumber);
            break;
        case 4:
            PopupUtils.open(newGameComponent);
            break;
        }
    }

}
