C323 Final Project Read me

Jason Mai jasmai@iu.edu
Darrion Shack dashack@iu.edu

April 30th

Here is how we divided the tasks:

Jason:
Grading and providing guidance for counter part team
Program planning (UML Diagrams)
Data Collection with core motion
Data processing with standard deviation
Sending data to the model
Getting tremor and gait data
Sending and storing data in the model


Darrion:
UI design
Persistant storage with core data which didn't work so now we're saving it in the file manager
Graphing data which didn't work either so now we're displaying data across time
Reminders tab
Struct management
Tabbed bar controller
Reminders Tableview controller

Our app is designed to help patients with parkinson's disease track their gait and tremor
patterns so that they can better understand how their symptoms are progressing. Each tab
in the tab bar correlates to what we are tracking. We also have a reminds tab to remind the 
patients of things they may need that also uses the User Notifications Framework. The symptom
tracking also uses the core motion frame work located in the Tremor and Gait ViewControllers
We initially planned for our 3rd framework to 
be core data however we were unable to use that so we now store persistant data in the file manager.
We are missing just one framework. We were going to use swift graphs to graph the data but we ran into problems
with it not working with UIKit so we scrapped the graphing plan with notifications instead.
You will need to download this app to test it. Works on iphones 12 and 13 for sure and might work for
iphones after iphones after 12.

Something cool I think you should check out is how we implemented standard deviation inorder tp
compress our data sets down inthe Model. It took a lot of work and is one of the main highlights of
this project.

In order to track your symptoms, just switch to the appropriate tab and start the tracking.
For gait, you will need to wait a bit for the collection to finish, make sure you don't stand still.

15