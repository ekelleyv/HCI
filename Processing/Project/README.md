Code Structure and Description
------------------------------

* Project.pde
	** The main class called by Processing. 
	** Instantiates two windows, one for the projector and one for debugging on the monitor. 
	** Handles the keypress events for initializing and displaying debugging information.

Detect.pde
	-Interfaces with the ARToolKit library to detect the tags from the video feed.

Translate.pde
	-Handles the interface with the homography library.
	-Draws debug information for tag detection.

Homography.pde (3rd Party Code)
	-Calculates the relationship between points in the camera space and projector space. 

Initialize.pde
	-Creates the display of the tag on the projector for initialization the homography.

TagLibary.pde
	-Data structure that contains all of the tags present on the board.

TagRow.pde
	-Data structure that contains all of the tags in a given row.

Tag.pde
	-Data structure that contains all of the information related to a detected tag, such as id, position in projector coordinates, and position in camera coordinates. 
	-Drawing methods for debugging tag location

