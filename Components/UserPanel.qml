import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

FocusScope {

    property alias icon: icon.source

    property alias name: name.text

    property alias password: passwordField.text

    property int session: sessionPanel.session

    FontLoader {
        id: iconfont
        source: Qt.resolvedUrl("../fonts/icons.ttf")
    }

    FontLoader {
        id: segoeuisl
        source: Qt.resolvedUrl("../fonts/segoeuisl.ttf")
    }

    FontLoader {
        id: segoeuil
        source: Qt.resolvedUrl("../fonts/segoeuil.ttf")
    }

    FontLoader {
        id: segoeui
        source: Qt.resolvedUrl("../fonts/segoeui.ttf")
    }

    Connections {
      target: sddm

        function onLoginFailed() {
            passwordField.visible = false
            passwordField.enabled = false
            falsePass.visible = true
            falsePass.focus = true
        }

        function onLoginSucceeded() {
            passwordField.visible = false
            truePass.visible = true
        }
    }

    Image {
        id: icon
        width: 192
        height: 192
        smooth: true
        visible: false

        x: -(icon.width / 2)
        y: -(icon.width * 2) + (icon.width / 2)
    }

    OpacityMask {
        anchors.fill: icon
        source: icon
        maskSource: mask
    }

    Item {
        id: mask
        width: icon.width
        height: icon.height
        layer.enabled: true
        visible: false

        Rectangle {
            width: icon.width
            height: icon.height
            radius: width / 2
            color: "black"
        }
    }

    Text {
        id: name
        color: "white"
        font.pointSize: 40
        font.family: segoeuil.name
        font.weight: Font.Thin
        renderType: Text.NativeRendering

        anchors {
            topMargin: 25
            horizontalCenter: icon.horizontalCenter
            top: icon.bottom
        }
    }

    PasswordField {
        id: passwordField
        visible: true
        x: -135

        anchors {
            topMargin: 25
            top: name.bottom
        }

        onTextChanged: {
            if (passwordField.text !== "") {
                passwordField.width = 226
                loginButton.x = passwordField.width + loginButton.width
                revealButton.x = passwordField.width
                revealButton.visible = true
            }

            else {
                passwordField.width = 258
                revealButton.visible = false
            }
        }

        Keys.onReturnPressed: sddm.login(model.name, password, session)
        Keys.onEnterPressed: sddm.login(model.name, password, session)

        LoginBg {
            id: loginBg

            x: -3

            LoginButton {
                id: loginButton

                ToolTip {
                    id: loginButtonTip

                    delay: 1000
                    timeout: 4800
                    leftPadding: 9
                    rightPadding: 9
                    topPadding: 7
                    bottomPadding: 7
                    visible: loginButton.hovered

                    contentItem: Text {
                        text: "Submit"
                        font.family: segoeuil.name
                        renderType: Text.NativeRendering
                        font.weight: Font.DemiBold
                        color: "white"
                    }

                    background: Rectangle {
                        color: "#2A2A2A"
                        border.width: 1.4
                        border.color: "#1A1A1A"
                    }
                }

                onClicked: {
                    sddm.login(model.name, password, session)
                }
            }

            RevealButton {
                id: revealButton
                visible: false
            }
        }
    }


    FalsePass {
        id: falsePass
        visible: false

        anchors {
            horizontalCenter: parent.horizontalCenter
            topMargin: 25
            top: name.bottom
        }
    }

    TruePass {
        id: truePass
        visible: false

        anchors {
            horizontalCenter: parent.horizontalCenter
            topMargin: 25
            top: name.bottom
        }
    }

    CapsOn {
        id: capsOn
        visible: false

        state: keyboard.capsLock ? "on" : "off"

        states: [
            State {
                name: "on"
                PropertyChanges {
                    target: capsOn
                    visible: true
                }
            },

            State {
                name: "off"
                PropertyChanges {
                    target: capsOn
                    visible: false
                }
            }
        ]

        anchors {
            horizontalCenter: parent.horizontalCenter
            topMargin: 25
            top: passwordField.bottom
        }
    }
}