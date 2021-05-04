# Track myself is a cross platform mobile app made in Flutter (currently supported in Android only).

It is made for Parkinson disease patients for tracking their medication and symptom level. Parkinson disease is a developing neurological disorder affecting the movement and body functionalities of humans, and it has different symptoms level for each patient and require different treatment plans that need to be customized for each patient at each period of time.


<img src="https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/Screenshot_20210315-122856.jpg" width="300">


The app has 6 main features:


1: Prescribing single medications and groups of medications (by doctors) to be taken by the patient.


<img src="https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/Screenshot_20210329-025043.jpg" width="300">


2: An accelerometer based game (with different levels) to assess the patients' symptoms to be played by the patients a few times daily.


<img src="https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/Screenshot_20210303-195121.jpg" width="300">



3: A daily symptoms survey to be filled by the patients, with a daily reminder sent to the user.


<img src="https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/Screenshot_20210305-001113.jpg" width="300">
<img src="https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/Screenshot_20210304-200030_One%20UI%20Home.jpg" width="300">


4: Medications logging (group medications and single booster medications) done by the patient whenever medications are taken.


<img src="https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/Screenshot_20210305-001210.jpg" width="300">
<img src="https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/Screenshot_20210305-001226.jpg" width="300">


5: Previous records pages to view previous game scores, daily surveys, medication intakes, with the option to delete records if needed.


<img src="https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/Screenshot_20210305-133520.jpg" width="300">


6: A dashboard to view charts presenting the patient's data over time, data viewed on Y-axis are game scores, daily surveys, medication adherence (calculated by the difference in time between the medication's optimal time and the time when the patient took this medication), to be viewed by the patient and the doctors to evaluate the changes in symptoms and decide if different tratment plan is needed. It can be accessed from: https://fadytawfeek.shinyapps.io/Track-Myself/ on any browser or directly from the app itself using the device ID. (Please open the screenshots for better quality).


<img src="https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/Screenshot_20210416-030634.jpg" width="300">


![alt text](https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/daily%20dashboard.png)


A 15-minute time difference red horizontal line is drawn in the medication adherence chart to serve as a break point of good and poor medication adherence, and a blue trendline is drawn in all charts to represent the trend of the all time data for the patient (for example if the game scores are increasing, the trendline will have a positive slope. X-axis represents date, and its format varies according to the date range selected (day, week, month):


![alt text](https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/weekly%20dashboard.png)


![alt text](https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/monthly%20dashboard.png)


For extended view of the data, 3 side tabs are used so that data is shown for every day even if the user chooses a long date range (and the date orientation is tilted when date range is too long).


![alt text](https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/med%20side.PNG)


![alt text](https://github.com/FadyTawfeek/track-myself-flutter-app/blob/master/sym%20side.PNG)

