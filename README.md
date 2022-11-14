# Vision Demo

Simple application using Vision framework to detect the main object in an image.

## Features 

- capture a photo with a camera or choose one from library
- image is processed using Vision framework and pre-trained SqueezeNet model to detect the main object of the photo 
- results with the most confidence percentage are shown in a form of tags 
- tags can be selected or deselected to choose which ones to save 
- image including tags is saved in Realm database 
- all images can be seen on the gallery screen 
- categories are shown on top of gallery screen and allow image filtering 

## Used libraries 

- Vision for image processing
- Realm for data storage 
- SnapKit for AutoLayout 
- Combine for reactive programming 
