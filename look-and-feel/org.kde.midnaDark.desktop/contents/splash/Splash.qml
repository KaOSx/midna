//Caledonia KSplash theme in QML v1.9 was made by Malcer <malcer[at]gmx[dot]com> <caledonia.sourceforge.net> <malcer.deviantart.com>. 
//
//Some rights reserved. This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 License. | 2015
//
//https://creativecommons.org/licenses/by-sa/3.0/

import QtQuick 2.2

Item {
    id: main

    width: screenSize.width
    height: screenSize.height
    // width: 300
    // height: 300


    property int stage
    property int iconSize: (screenSize.width <= 1024) ? 32 : 64

    
    
    //  SEQ
    onStageChanged: {
        if (stage == 1) {
 
            background.opacity = 1
 
	    spin.opacity = 1 
 
        }
        if (stage == 2) {
 

	    spin.opacity = 1

        }
        if (stage == 3) {
 
            
	    spin.opacity = 1 

        }
        if (stage == 4) {
 
	    spin.opacity = 1
 
        }
        if (stage == 5) {

            
	    spin.opacity = 1 
 
        }
        if (stage == 6) {
 
	    spin.opacity = 1 
 
        }
    }
    
    //  SEQ END


// BACKGROUND

    Image {
        id: background
	source: "images/background.jpg"
	 anchors.fill: parent
 

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        opacity: 0
 
    }
    
        Image {
      id: logo
      
      height: 150
      width: 150
      
      x: (parent.width - width) /2
      y: parent.height / 2 - height
      
      source: "images/logo.png"
    }

 
    Image {
        id: spin

        height: 48
        width: 48
        smooth: true

        x: (background.width - width) / 2
        y: (background.height - height) / 1.5

        source: "images/spin.png"

        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 1000; easing { type: Easing.InOutQuad } } }

        NumberAnimation {
            id: animateRotation
            target: spin
            properties: "rotation"
            from: 0
            to: 360
            duration: 750

            loops: Animation.Infinite
            running: true
        }

    }


}
