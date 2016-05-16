import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0

import TextConverter 1.0

ApplicationWindow {
    width: 640
    height: 480
    color: "#f1f1f1"

    HTMLText {
        id: htmltext
        text: "hello"
    }

    toolBar: ToolBar {
        width: parent.width

        RowLayout {
            width: parent.width
            height: parent.height

            Button {
                Layout.alignment: Qt.AlignRight
                text: "Copy to HTML"

                onClicked: {
                    htmltext.copyToClip(mdarea.text)
                }
            }
        }
    }

    RowLayout {
        width: parent.width
        height: parent.height

        TextArea {
            id: mdarea
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: (parent.width / 2) - 5
            Layout.preferredHeight: parent.height - 10
            text: mdtext
            Keys.onPressed: {
                htmltext.setHTMLText(mdarea.text);
                rtarea.text = htmltext.text
            }
        }

        TextArea {
            id: rtarea
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: (parent.width / 2) - 5
            Layout.preferredHeight: parent.height - 10
            textFormat: TextEdit.RichText
            text: rttext
            onActiveFocusChanged: {
                if(!activeFocus) {
                    rtarea.textFormat = TextEdit.RichText
                } else {
                    rtarea.textFormat = TextEdit.PlainText
                    htmltext.setHTMLText(mdarea.text)
                    rtarea.text = htmltext.text
                }
            }
        }
    }

}
