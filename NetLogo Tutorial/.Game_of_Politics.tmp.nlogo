turtles-own [
  A_party?     ;; A party supporters
  B_party?     ;; B party supporters
  C_party?     ;; C party supporters
  D_party?     ;; D party supporters
  No_party?    ;; No party supporters
  A_adoption   ;; Points on A ideology
  B_adoption   ;; Points on B ideology
  C_adoption   ;; Points on C ideology
  D_adoption   ;; Points on D ideology
]

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all
  set-default-shape turtles "person"
  make-turtles
  identity
  reset-ticks
end

to make-turtles
  create-turtles num-people [
    ;; Set no party support and no adoption
    set A_party? false
    set B_party? false
    set C_party? false
    set D_party? false
    set No_party? false
    set A_adoption 0
    set B_adoption 0
    set C_adoption 0
    set D_adoption 0
    ;; Set random coordinates
    setxy random-xcor random-ycor
  ]
end

to identity
  ;; Give all turtles an initial identity based on parameters
  let A_supporters ((A_party_supporters / 100) * num-people)
  let B_supporters ((B_party_supporters / 100) * num-people)
  let C_supporters ((C_party_supporters / 100) * num-people)
  let D_supporters ((D_party_supporters / 100) * num-people)
  ask n-of A_supporters turtles [
    set A_party? true
    set color red
    set A_adoption support_threshold
  ]
  ask n-of B_supporters turtles with [not A_party?] [
    set B_party? true
    set color blue
    set B_adoption support_threshold
  ]
  ask n-of C_supporters turtles with [not A_party? and not B_party?] [
    set C_party? true
    set color yellow
    set C_adoption support_threshold
  ]
  ask n-of D_supporters turtles with [not A_party? and not B_party? and not C_party?] [
    set D_party? true
    set color green
    set D_adoption support_threshold
  ]
    ask turtles with [not A_party? and not B_party? and not C_party? and not D_party?][
      set No_party? true
      set color white
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;
;;; Main Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;

to go
  ;; Check model - condition to stop the simulation
  if all? turtles [ A_party? ] [ stop ]
  if all? turtles [ B_party? ] [ stop ]
  if all? turtles [ C_party? ] [ stop ]
  if all? turtles [ D_party? ] [ stop ]
  if all? turtles [ No_party? ] [ stop ]
  ;; Execute procedures
  move
  spread_opinion
  tick
end

to spread_opinion
  ask turtles [
    ;; Set values - compare influences upon the turtles on each square
    let influence_control 0
    let A_influence 0
    let B_influence 0
    let C_influence 0
    let D_influence 0

    let A_general_influence A_party_influence * 0.02
    let B_general_influence B_party_influence * 0.02
    let C_general_influence C_party_influence * 0.02
    let D_general_influence D_party_influence * 0.02
    ask (turtles-at 1 1) with [A_party?][
     set A_influence A_influence + (A_adoption * A_general_influence)
    ]
    ask (turtles-at 1 1) with [B_party?][
     set B_influence B_influence + (B_adoption * B_general_influence)
    ]
    ask (turtles-at 1 1) with [C_party?][
     set C_influence C_influence + (C_adoption * C_general_influence)
    ]
    ask (turtles-at 1 1) with [D_party?][
     set D_influence D_influence + (D_adoption * D_general_influence)
    ]
    ;; Set resilience - individuals will try to keep their ideology
    let turtle_resilience resilience * 0.02
    if A_party? [set A_influence A_influence * turtle_resilience]
    if B_party? [set B_influence B_influence * turtle_resilience]
    if C_party? [set C_influence C_influence * turtle_resilience]
    if D_party? [set D_influence D_influence * turtle_resilience]
    ;; If one (and just one!) ideology prevail in the area, its change the local agent's points
    let max_influence max (list A_influence B_influence C_influence D_influence)
    foreach (list A_influence B_influence C_influence D_influence) [ x -> if x = max_influence [ set influence_control influence_control + 1 ]]
    if A_influence = max_influence and influence_control = 1 [
      set A_adoption A_adoption + 1
      set B_adoption B_adoption - 1
      set C_adoption C_adoption - 1
      set D_adoption D_adoption - 1
      if A_adoption > support_threshold [set A_adoption support_threshold]
    ]
    if B_influence = max_influence and influence_control = 1 [
      set B_adoption B_adoption + 1
      set A_adoption A_adoption - 1
      set C_adoption C_adoption - 1
      set D_adoption D_adoption - 1
      if B_adoption > support_threshold [set B_adoption support_threshold]
    ]
    if C_influence = max_influence and influence_control = 1 [
      set C_adoption C_adoption + 1
      set A_adoption A_adoption - 1
      set B_adoption B_adoption - 1
      set D_adoption D_adoption - 1
      if C_adoption > support_threshold [set C_adoption support_threshold]
    ]
    if D_influence = max_influence and influence_control = 1 [
      set D_adoption D_adoption + 1
      set A_adoption A_adoption - 1
      set C_adoption C_adoption - 1
      set B_adoption B_adoption - 1
      if D_adoption > support_threshold [set D_adoption support_threshold]
    ]
    ;; Have the agent change its condition ? Change classes
    set influence_control 0
    let max_ideology max (list A_adoption B_adoption C_adoption D_adoption)
    foreach (list A_adoption B_adoption C_adoption D_adoption) [x -> if x = max_ideology [set influence_control influence_control + 1]]
    ifelse influence_control = 1 [
      if A_adoption = max_ideology [
        ifelse A_adoption >= support_threshold [
          set color red
          set A_party? true
          set B_party? false
          set C_party? false
          set D_party? false
          set No_party? false
        ]
        [
          set color white
          set A_party? false
          set B_party? false
          set C_party? false
          set D_party? false
          set No_party? true
        ]
      ]
      if B_adoption = max_ideology [
        ifelse B_adoption >= support_threshold [
          set color blue
          set B_party? true
          set A_party? false
          set C_party? false
          set D_party? false
          set No_party? false
        ]
        [
          set color white
          set A_party? false
          set B_party? false
          set C_party? false
          set D_party? false
          set No_party? true
        ]
      ]
      if C_adoption = max_ideology [
        ifelse C_adoption >= support_threshold [
          set color yellow
          set C_party? true
          set B_party? false
          set A_party? false
          set D_party? false
          set No_party? false
        ]
        [
          set color white
          set A_party? false
          set B_party? false
          set C_party? false
          set D_party? false
          set No_party? true
        ]
      ]
      if D_adoption = max_ideology [
        ifelse D_adoption >= support_threshold [
          set color green
          set D_party? true
          set B_party? false
          set C_party? false
          set A_party? false
          set No_party? false
        ]
        [
          set color white
          set A_party? false
          set B_party? false
          set C_party? false
          set D_party? false
          set No_party? true
        ]
      ]
    ]
    [
      set color white
      set No_party? true
      set A_party? false
      set B_party? false
      set C_party? false
      set D_party? false
    ]
  ]
end

to move
  ;; Move agents
  ask turtles [
    fd 1
    rt random 30
    lt random 30
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
390
20
849
480
-1
-1
11.0
1
10
1
1
1
0
1
1
1
-20
20
-20
20
1
1
1
ticks
30.0

BUTTON
10
20
90
55
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
115
65
195
100
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
985
200
1175
233
num-people
num-people
0
600
300.0
1
1
Unit(s)
HORIZONTAL

BUTTON
10
65
90
100
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
10
165
380
480
Number of Supporters vs Time
Time
NIL
0.0
10.0
0.0
1.0
true
true
"" ";;if variant = \"environmental\" [\n;;  create-temporary-plot-pen \"patches\"\n;;  plotxy ticks count patches with [ p-infected? ] / count patches\n;;]"
PENS
"A Party" 1.0 0 -2674135 true "" "plot count turtles with [ A_party? ] / count turtles"
"B Party" 1.0 0 -13345367 true "" "plot count turtles with [ B_party? ] / count turtles"
"C Party" 1.0 0 -1184463 true "" "plot count turtles with [ C_party? ] / count turtles"
"D Party" 1.0 0 -10899396 true "" "plot count turtles with [ D_party? ] / count turtles"
"Non-Align" 1.0 0 -16777216 true "" "plot count turtles with [ No_party? ] / count turtles"

SLIDER
885
25
1062
58
A_party_supporters
A_party_supporters
0
100 - B_party_supporters - D_party_supporters - D_party_supporters
20.0
1
1
%
HORIZONTAL

SLIDER
885
65
1062
98
B_party_supporters
B_party_supporters
0
100 - C_party_supporters - A_party_supporters - D_party_supporters
20.0
1
1
%
HORIZONTAL

SLIDER
885
105
1062
138
C_party_supporters
C_party_supporters
0
100 - B_party_supporters - A_party_supporters - D_party_supporters
20.0
1
1
%
HORIZONTAL

SLIDER
885
145
1062
178
D_party_supporters
D_party_supporters
0
100 - B_party_supporters - A_party_supporters - C_party_supporters
20.0
1
1
%
HORIZONTAL

SLIDER
1095
25
1267
58
A_party_influence
A_party_influence
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
1095
65
1267
98
B_party_influence
B_party_influence
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
1095
105
1267
138
C_party_influence
C_party_influence
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
1095
145
1267
178
D_party_influence
D_party_influence
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
890
255
1062
288
resilience
resilience
0
200
50.0
1
1
%
HORIZONTAL

SLIDER
1100
255
1282
288
support_threshold
support_threshold
1
10
5.0
1
1
Unit(s)
HORIZONTAL

MONITOR
70
110
127
155
B Party
count turtles with [ B_party? ]
1
1
11

MONITOR
130
110
187
155
C Party
count turtles with [ C_party? ]
1
1
11

MONITOR
190
110
247
155
D Party
count turtles with [ D_party? ]
1
1
11

MONITOR
10
110
67
155
A Party
count turtles with [ A_party? ]
1
1
11

MONITOR
250
110
312
155
Non Align
count turtles with [ No_party? ]
1
1
11

@#$#@#$#@
## ACKNOWLEDGMENT

This model was created as a final project for the “Introduction to Agent-Based Modelling”, an online course provided by Santa Fe Institute throughout Complexity Explorer. 

Conceived initially to modelling the dynamic of opinions on stock market’s environment, this model quickly evolves into the current format still focused on opinion dynamics but rather concerned on a social-political-based background. Feel free to improve and share.

## WHAT IS IT?

“Game of Politics” is a result of a mental social experiment which tries to explanate the dynamics of an election. A certain group of people are freely walking on the environment, they belong intrinsically to one, and just one, political class. There are 5 political classes onboard, they are composed by 4 distinct parties (A, B, C and D) and a Non-Align group made up by people which do not support actively any political view.

The main idea is to explore the dependency of initial parameters and features on the stochastic development of the system and to check out for patterns which consistently repeat themselves despite randomness to propose hints on how political support and speech spread along societies.


## HOW IT WORKS

Once pressed, the SETUP button creates a certain population of agents on-field based on the number informed on “num-people” slider (right side).
The GO button runs the simulation indefinitely until one political party achieves hegemony (100% of all supporters) or until all agents adopt the “non-alignment” posture. The GO ONCE button runs the simulations just one ticker ahead but not changes the results at all.
The model simulates how social groups try to achieve political hegemony on certain fields and context by exchanging opinions individually. All agents contain several points on each political branch, if they earn a minimal number of points in a certain branch (and this number is superior to a minimal threshold) they are so considered as an active member of the group and immediately start to try to convince people around, if none of this condition is achieved they remain as non-align agents.
Individuals receive points by interact with party members inside an area. If they contact more individuals within a group X they are persuade by them. Won who is able to achieve 100% of engagement. 


## HOW TO USE IT

The NUM-PEOPLE slider controls the number of people living in the world.

The “PARTY_SUPPORTERS” sliders (Ex.: “A_party_supporters”) on right side control the initial percentage of the population belonging to each group. Notice that you are limited on setting a maximum a 100% of the population to belong to each of 4 groups. If less than a 100% of population is designated to a group, the additional people are automatically considered as “non-align” by default.

The “PARTY_INFLUENCE” sliders (Ex.: “C_party_influence”) on right side measure how much influent a political group is. As more a group is influent the easier shall it be to “convince” other people on join their cause.

The “RESILIENCE” slider provides a parameter associated on how hard it can be to people to change their political opinion, by default this value is 50%. High taxes of resilience mean people are most engaged on defend the cause they already have joined. 
  
The “SUPPORT_THRESHOLD” slider define the minimum number of points on each group an agent need to be consider as part of a party.


## THINGS TO NOTICE

How different parameters affect the election’s result?

Try to find out if there is some combinations which could always provide the same result, after some attempts you should be able to realize how the population length naturally defines the sensibility of the system on parameters and in which conditions stochasticity becomes more relevant than some parameters. 
Pay attention on how long it takes to certain party to be extinct, if the curves have always the same general pattern and if is there any possible scenarios where the non-alignment should prevail.


## THINGS TO TRY

Try to vary the general number of agents onboard and see how should it impact the dependency on parameters, thy to run models on a perfect competition scenario (with all the parties with the same initial supporters’ number and influence) and in no-balanced conditions, then elaborate hypothesis about: What is more relevant for a party to win? Being numerous or being influential? 
 
Then, start to slightly change the initial threshold and/or the resilience tax. Does that increase or decrease the number of non-align people? At the end, keeps higher taxes of initial threshold and resilience and answer the question: “Can a high resilience framework with high ‘ideological barriers’ (given by the initial threshold) provides and environment of ‘eternal conflict’?    


## EXTENDING THE MODEL

Feel free to extend this model on higher levels, additional features could contemplate a more active role for non-align agents which are represent on this model as merely passive political agents that took, they decisions based only on its neighbourhood predominance and on its past records.
 
Another idea should be to create more individual characteristics or to append external regulation or rules trying to find out different possible behaviours that could emerge. 

Follow gPergher98 on GitHub.  

## RELATED MODELS

Check out the “SIMPLE ECONOMY” model on Economics section within NetLogo’s Libraries.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="population-density" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>ticks</metric>
    <enumeratedValueSet variable="variant">
      <value value="&quot;mobile&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="connections-per-node">
      <value value="4.1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="num-people" first="50" step="50" last="200"/>
    <enumeratedValueSet variable="num-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-decay">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="degree" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>count turtles with [infected?]</metric>
    <enumeratedValueSet variable="num-people">
      <value value="200"/>
    </enumeratedValueSet>
    <steppedValueSet variable="connections-per-node" first="0.5" step="0.5" last="4"/>
    <enumeratedValueSet variable="disease-decay">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="variant">
      <value value="&quot;network&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-infected">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="environmental" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>ticks</metric>
    <enumeratedValueSet variable="num-people">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="connections-per-node">
      <value value="4"/>
    </enumeratedValueSet>
    <steppedValueSet variable="disease-decay" first="0" step="1" last="10"/>
    <enumeratedValueSet variable="variant">
      <value value="&quot;environmental&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-infected">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="density-and-decay" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>ticks</metric>
    <enumeratedValueSet variable="variant">
      <value value="&quot;environmental&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="disease-decay" first="0" step="1" last="10"/>
    <enumeratedValueSet variable="num-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="num-people" first="50" step="50" last="200"/>
    <enumeratedValueSet variable="connections-per-node">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
