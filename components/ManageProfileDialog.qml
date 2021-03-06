import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "../js/localStorage.js" as Settings
import QtQuick.LocalStorage 2.0

Component {
    id: editProfileDialog

    Dialog {
        objectName: "Edit profile"
        id: editProfileDialogue
        title: i18n.tr("Edit profile")
        width: parent.width
        anchors.topMargin: units.gu(-20)


        Column {
            width: parent.width
            spacing: units.gu(2)

            UbuntuShape {
                width: parent.width - units.gu(4)
                height: mainView.height/18
                radius: "medium"
                color: "#AEA79F"
                anchors.horizontalCenter: parent.horizontalCenter
                TextField {
                    id:firstnameField
                    anchors.fill: parent
                    //placeholderText: i18n.tr("Firstname")
                    text: Settings.getUserFirstName(editUserId)
                    color: "white"
                    onFocusChanged: {
                        if (firstnameField.focus)
                            firstnameField.color = "#333333"
                        else firstnameField.color = "white"
                    }
                }
            }
            UbuntuShape {
                width: parent.width - units.gu(4)
                height: mainView.height/18
                radius: "medium"
                color: "#AEA79F"
                anchors.horizontalCenter: parent.horizontalCenter
                TextField {
                    id:lastnameField
                    text: Settings.getUserLastName(editUserId)
                    anchors.fill: parent
                    //placeholderText: i18n.tr("Lastname")
                    color: "white"
                    onFocusChanged: {
                        if (lastnameField.focus)
                            lastnameField.color = "#333333"
                        else lastnameField.color = "white"
                    }
                }
            }



            Row{
                width: parent.width
                spacing: units.gu(1)

                SudokuDialogButton{
                    id:okButton
                    buttonText: i18n.tr("OK")
                    width: parent.width/2;
                    size: units.gu(5)
                    buttonColor: sudokuBlocksGrid.dialogButtonColor2
                    textColor: sudokuBlocksGrid.dialogButtonTextColor
                    //border.color: "transparent"
                    onTriggered: {

                        if(lastnameField.text!="" && firstnameField.text!="")
                        {

                            if(!Settings.existProfile( lastnameField.text, firstnameField.text))
                            {

                                Settings.updateProfile(editUserId, lastnameField.text, firstnameField.text);
                                var userId = currentUserId
                                currentUserId = -1
                                currentUserId = userId

                                PopupUtils.close(editProfileDialogue)
                            }else{
                                PopupUtils.close(editProfileDialogue)
                            }


                        } else{
                            mainView.showAlert(i18n.tr("Warning"), i18n.tr("Lastname and firstname must not be empty."), okButton)
                        }





                    }
                }

                SudokuDialogButton{
                    objectName: "deleteButton"
                    id: deleteButton
                    buttonText: i18n.tr("Delete")
                    buttonColor: sudokuBlocksGrid.dialogButtonColor1
                    textColor: sudokuBlocksGrid.dialogButtonTextColor
                    //border.color: "transparent"
                    width: parent.width/2;
                    size: units.gu(5)
                    onTriggered: {
                        Settings.deleteProfile(editUserId)
                        if(editUserId == currentUserId)
                            currentUserId = -1


                        PopupUtils.close(editProfileDialogue)
                    }
                }
            }
            SudokuDialogButton{
                anchors.horizontalCenter: parent.horizontalCenter
                objectName: "profileCancelButton"
                buttonText: i18n.tr("Cancel")
                buttonColor: sudokuBlocksGrid.dialogButtonColor3
                textColor: sudokuBlocksGrid.dialogButtonTextColor
                //border.color: "transparent"
                width: parent.width/2;
                size: units.gu(5)
                onTriggered: {
                    PopupUtils.close(editProfileDialogue)
                }
            }


        }


    }
}

