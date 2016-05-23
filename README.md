

# AskMrCoach

AskMrCoach is a recommender system that allows the user to insert a state of the champion select fase to obtain a recommended champion for that situation. The system will recommend 10 champs, 5 influenced by the mastery of the summoner with that champion and other 5 that will be good in that team comp without caring  about the skill of the user with that champion.

Bugs detected (fixed in askmrcoach2):
- Divide by 0 in function with a wrong =+

improvements on askmrcoach2
- bad looking visuals
- all supported regions regions added
- works with any summoner from the supported regions
- improved recommender algorithm


A live version of the most recent application can be found here:
https://askmrcoach2.herokuapp.com

##How to use
Select the champions and roles of your teammates or enemies and put the poro in your preferred rol and the click the Recommend Button


##How the system works
The system is based on the similarity between the composition of champions in the distinct games. 
To do this, the distinct compositions are represented like vectors on the database.
The vector structure is as follows:

[id_blue_top_champ ,id_blue_jg_champ, id_blue_mid_champ, id_blue_adc_champ, id_blue_supp_champ, id_red_top_champ ,id_red_jg_champ, id_red_mid_champ, id_red_adc_champ, id_red_supp_champ, wins_blue, wins_red]

Using the mongo aggregation framework the system calculates the best champion for the role and composition that were entered as parameter. 

The performance rate is calculated using compositions that are at least 50% similar to the parameters. For instance, if you input 4 champs the similar compositions have atleast 2 champs in the same position as the parameters. }

The performance rate is the probability to win of the champ in the given conditions  X The mastery lvl of that champ

You can see the dataset used for this project here: 

###Public database acces: 
mongodb://askmrcoach:askmrcoach1@ds023388.mlab.com:23388/ritochallenge

##Tech specs
ETL: java with Orianna lib to access Riot API
Database:
Data processing: Mongo Aggregate framework
FrontEnd: Ruby on Rails with taric gem to access Riot API

##Future work
- Include recommended start items, core items masteries runes and summoners
- improve UI
