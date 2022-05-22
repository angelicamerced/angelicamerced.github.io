;; WEST NILE VIRUS
;; Model that is based and modified from http://www.netlogoweb.org/launch#http://ccl.northwestern.edu/netlogo/community/WNV%20model%20181026.nlogo

;;;;
;;; Global variables: humans, mosquitoes, robins and cardinals are breeds
;;;;

breed [ humans human ]
breed [ mosquitoes mosquito ]
breed [ robins robin ]
breed [ cardinals cardinal ]

humans-own [ state Recovery-Rate ]
mosquitoes-own [ state Life-Span ]
robins-own [ state Life-Span ]
cardinals-own [ state ]

globals
[
  total-birds
  robins-sig
]

;;;;
;;;SETUP PROCEDURES
;;;;

to setup
  clear-all
  reset-ticks
  ask patches [ set pcolor white ]
  set-default-shape humans "human"
  set-default-shape mosquitoes "circle"
  set-default-shape robins "robin"
  set-default-shape cardinals "cardinal"
   create-humans Number-of-Humans
   [
     setxy random-xcor random-ycor
     set size 2
     set color 65
     set state "susceptible"
     set Recovery-Rate 0
   ]

  create-mosquitoes Number-of-Mosquitoes
  [
    setxy random-xcor random-ycor
    set size 0.6
    set color yellow
    set state "susceptible"
    set Life-Span 15 + random 30
  ]

; the season is hypothesized to start on June 1 and run until October 1 (120 days)

  create-robins Number-of-Robins - Number-of-Infected-Robins
  [
    setxy random-xcor random-ycor
    set size 1
    set robins-sig 40
    set Life-Span 121
    set state "susceptible"
    set color red
  ]

  create-robins Number-of-Infected-Robins
  [
    setxy random-xcor random-ycor
    set size 1.5
    set Life-Span 121
    set state "infected"
    set color orange
  ]

  create-cardinals Number-of-Cardinals
  [
    setxy random-xcor random-ycor
    set size 0.8
    set state "susceptible"
    set color red
  ]
end

;;;
;;; GO PROCEDURES
;;;

to go
  ask humans
  [
    forward 1
    Mosquito-Infects-Humans
  ]

  ask mosquitoes
  [
      forward 1
      lt 45
      set Life-Span Life-Span - 1
      Robin-Infects-Mosquito
      Mosquito-Dies
  ]

  ask robins
  [
    jump random-float 3
    rt 30
    set Life-Span Life-Span - 1
    Mosquito-Infects-Bird
    Robin-Dies
  ]

  ask cardinals
  [
    jump random-float 2
    lt 30
    Mosquito-Infects-Bird
  ]

  ; Tick counter
  tick                             ; Increments (adds 1 to) the tick counter -- another day has passed.

  if count robins with [ state = "infected" ] = 0 and count mosquitoes with [ state = "infected" ] = 0 [stop]  ; if there are no infected robins or mosquitoes, stop
  if ticks > 120 [ stop ]                                                                                      ; if the summer is over, stop

end

;;;
;;; METHODS
;;;

to Mosquito-Infects-Humans
  if count robins-here = 0 and count cardinals-here = 0 and any? mosquitoes-here with [ state = "infected" ] and any? humans-here with [ state = "susceptible" ]
     [ ask one-of humans-here with [ state = "susceptible" ]
  [
    set state "infected"
    set color red

  ]]

end

to Mosquito-Infects-Bird
 set total-birds count robins-here + count cardinals-here
    if any? mosquitoes-here with [ state = "infected" ] and total-birds > 0
    [
    ifelse random-float 1 <= count robins-here / total-birds


      [
      ask one-of robins-here
         [
         set state "infected"
         set color black
    ]]
  [
    if count cardinals-here > 0
      [
      ask one-of cardinals-here
         [
         set state "infected"
  ]]]]
end

to Robin-Infects-Mosquito
 set total-birds count robins-here + count cardinals-here
    if state = "susceptible" and total-birds > 0
    [
    if random-float 1 <= count robins-here with [ state = "infected" ] / total-birds and random-float 100 <= Host-Competence
         [
         set state "infected"
         set color red
    ]]
end

to Mosquito-Dies
  if Life-Span <= 0
  [
    setxy random-xcor random-ycor
    set state "susceptible"
    set color yellow
    set Life-Span 15 + random 30
  ]
end

to Robin-Dies
  if Life-Span <= 0  [ die ]
end
@#$#@#$#@
GRAPHICS-WINDOW
12
69
643
579
-1
-1
15.2
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
-16
16
1
1
1
ticks (days)
30.0

BUTTON
694
380
843
434
Setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
695
452
842
506
Run
Go
T
1
T
OBSERVER
NIL
R
NIL
NIL
1

SLIDER
652
144
880
177
Number-of-Humans
Number-of-Humans
0
1000
10.0
5
1
NIL
HORIZONTAL

PLOT
14
582
736
901
Population Dynamics
Days
Number
0.0
120.0
0.0
5.0
true
true
"" ""
PENS
"Infected Humans" 1.0 0 -2674135 true "" "if ticks > 0 and ticks < 120 [ plot count humans with [ state = \"infected\" ] ]"
"Infected Mosquitoes" 1.0 0 -13345367 true "" "if ticks > 0 and ticks < 120 [ plot count mosquitoes with [ state = \"infected\" ]]"
"Infected Robins" 1.0 0 -10899396 true "" "if ticks > 0 and ticks < 120 [ plot count robins with [ state = \"infected\" ]]"

MONITOR
740
662
874
715
Infected People
count humans with [ state = \"infected\" ]
0
1
13

SLIDER
654
285
881
318
Number-of-Infected-Robins
Number-of-Infected-Robins
0
20
1.0
1
1
NIL
HORIZONTAL

SLIDER
652
179
881
212
Number-of-Mosquitoes
Number-of-Mosquitoes
0
2000
300.0
5
1
NIL
HORIZONTAL

SLIDER
652
215
879
248
Number-of-Robins
Number-of-Robins
0
1000
10.0
1
1
NIL
HORIZONTAL

MONITOR
744
767
874
812
Infected Robins
count robins with [ state = \"infected\" ]
0
1
11

SLIDER
652
250
880
283
Number-of-Cardinals
Number-of-Cardinals
0
1000
0.0
5
1
NIL
HORIZONTAL

SLIDER
654
320
880
353
Host-Competence
Host-Competence
0
100
0.2
0.1
1
%
HORIZONTAL

MONITOR
742
719
874
764
Infected Mosquitoes
count mosquitoes with [ state = \"infected\" ]
0
1
11

@#$#@#$#@
## WHAT IS IT?

A computer simulation that permits students to model some of the ecological factors affecting the shape of an outbreak of West Nile Virus (WNV).

## HOW IT WORKS

NetLogo allows you to give commands to two sorts of entities:  "turtles" and "patches". Turtles are agents that can move around. Patches are little squares of turf; the display screen is divided into 41 x 33 = 1353 patches. In this model, the only command given to the patches sets the color, gray. 

On the other hand, there are four different "breeds" of turtle:  humans, robins, cardinals, and mosquitoes. WNV enters the model on (at least one) infected robin. Depending on a robin's "host competence", when a mosquito bites an infected robin, the mosquito might become infected, too. Then, when the mosquito bites someone else -- human, robin, or cardinal -- that individual becomes infected. Humans and cardinals have zero host competence; i.e., even if they are infected, a mosquito cannot become infected by biting them. Mosquitoes do not bite each other.

"Host competence" means the ability of an infected "host" -- a creature other than a mosquito -- to pass on the infection when bitten by a mosquito. Some animals, like the robin, have high host competence, meaning that they are relatively likely to pass on the infection to a biting mosquito. (In this model, robins' host competence is adjustable: experiment!) Other animals, like cardinals and humans, have very low or even zero host competence with respect to WNV. Even when a cardinal is infected, no matter how sick he is, he will not pass on the disease to a biting mosquito. Host competence differs by disease; humans, for example, have effectively zero host competence for WNV, but positive host competence for zika. If a mosquito bites a person with the zika virus, there is a very good chance that the mosquito will become infected.

The model runs for 120 days, intended to simulate the high-WNV risk months June, July, August and September. (In the other seasons, it's too cold for mosquitoes.) In this model, the initial population of robins is set on June 1. Some robins may die, and others may migrate away. No robins are born after June 1. In real life, some robins may live through the summer and, indeed, stay on all winter, but winter is beyond the scope of this model. Mosquitoes, on the other hand, have a relatively short life span, but whenever a mosquito dies, another uninfected mosquito is born to take its place -- so the mosquito population remains constant.

Cardinals do not die. They can become infected with WNV, but biting an infected cardinal will not pass WNV on to the biting mosquito -- cardinals have zero host competence. Cardinals are present in the model to simulate the "dilution effect". The idea of dilution is that the more zero-competence birds present, the more they will be bitten by mosquitoes, and the fewer mosquitoes will become infected and able to pass the disease to humans. Cardinals are not, in real life, the only zero-competence birds that exist; for the model, however, the distinction between cardinals and grackles and blue jays is irrelevant (Why?). Similarly, robins are not the only positive-competence hosts -- indeed, not all such hosts are even birds -- but for the purpose of the model, one positive-competence host is sufficient.

In real life, most humans who get WNV get only mildly sick, a few get very sick, and a very few die. Humans do not recover; they carry the WNV virus for the rest of their lives. However, the primary focus of this model is in the infected robin - mosquito - susceptible robin chain, not the ultimate effect of WNV.

## HOW TO USE IT

Use the slider bars to set:

human population size
robin population size
cardinal population size
mosquito population size

human movement factors ("angle"):  All the "turtles" (NetLogo-speak for agents) move in circles. By adjusting the "angle" you can adjust the size of the circles. The smaller the angle, the bigger the circle: 0 means they move in a straight line; 90 means they move in a small square. (NB. You can adjust the birds' and mosquitoes' movement angles, too, but you have to do it within the code. There is no slider bar for the animals.)

(Also, note that any agent who moves off the right (left) side of the screen immediately reappears on the left (right) side, at the same latitude. Similarly, anybody who moves off the top (bottom) of the screen immediately reappears at the bottom (top).)

initial number of infected robins:  Somebody has to introduce the infection into the
     community for the plague to begin.

percentage of robins who migrate in August
     Most robins migrate away in August. Some stay on all winter. 

robins' host competence (as percentage)
     Host competence is explained under "How It Works", above.

parameters of robins' migration
     This addresses the question, "When do migrating robins (remember, some robins stay put all winter) migrate?" In this model, robins' departure date is set by a gamma distribution (which is, in fact, fairly similar to the more-familiar normal distribution). Robins-Avg refers to the mean (average) departure date: Robins-Avg = 75 means that about half the migrating robins have departed by the 75th day of the model, i.e. August 15. 

## THINGS TO NOTICE

The intent of this model is to generate some insight into the ecological causes and consequences of an epidemic. Of course, this model is very simple. What factors are omitted? Are they important? If so, do you think you could add them to the model?

One important note:  This model makes extensive use of random numbers. They govern whether a robin is going to migrate, whether it is a competent host, whether it is bitten by a nearby mosquito, and many other things. This means for any collection of slider settings, each run of the model will be different. In particular, sometimes a lot of people will get sick, sometimes hardly anyone (even nobody) will get sick. To get an accurate picture of the effects of your selecting slider settings, you have to run the model several times and -- at least -- make mental notes of the outcomes. (It is possible to record the outcomes of each trial for statistical analysis, using an add-on called "Behavior Space" (under the "Tool" pull-down menu), but unless you are confident of your ability with Excel or some other spreadsheet program and know something about statistics, you'll probably become frustrated if you try it. (But... go ahead! Who knows what you'll figure out? That's the fun of NetLogo.))


## THINGS TO TRY

By adjusting the slider bars, try to mimic the documented pattern of WNV outbreaks. For example, in the Washington DC area a few years ago, no humans got WNV until about the first of August, then, in August and September a few people got sick. The actual numbers don't matter, because in this model you have at most 1,000 people, where in the Washington - Baltimore area you have several million. (NetLogo will allow you to write a program with ten million people, but you'd need a supercomputer to run it.) But see if you can reproduce the pattern -- no WNV until mid-summer, then several (but not an overwhelming number of) cases. 


## EXTENDING THE MODEL

What factors are omitted? Here are a few:

tree cover (degree of urbanization)
weather (esp. rain and heat) -- especially its effect on mosquito populations
baby robins (typically born in late June and July -- they are born uninfected)
sleeping ("roosting") habits of robins -- do they congregate near mosquitoes?
public health measures -- efforts to suppress the mosquito population
additional species of bird (for example, crows are highly susceptible to WNV)
what else?


## NETLOGO FEATURES

In NetLogo, each "breed" (here, people, birds or mosquitoes) consists of many agents who behave independently within user-defined guidelines such as infectiousness.  Thus, the model conceives biological systems as comprising of individual organisms who can be born, get sick, infect others, die, migrate and do other things while their peers remain unaffected at home. 

This is the principal difference between this model and the formal mathematical treatment, usually called the "SIR" model, in which all the members of each breed are treated in the aggregate, not as individuals.


## RELATED MODELS

Compare to the Virus program in the Models library, under Biology.
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

cardinal
false
0
Polygon -7500403 true true 64 89 16 105 68 109 68 91 66 89
Polygon -2674135 true false 60 85 80 69 98 69 120 75 136 89 134 113 124 137 150 161 208 191 242 209 240 243 170 253 100 245 64 203 52 155 78 133 54 109 60 85 60 91 62 89 62 89
Polygon -2674135 true false 96 71 122 55 126 71 146 75 120 87 112 91 100 71 100 71 100 71 104 69 106 73 98 75 100 71 98 73
Polygon -2674135 true false 224 217 274 183 248 227 282 233 216 245 228 217 228 215 218 217 222 215 232 215
Circle -16777216 true false 90 85 8

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

human
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

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

robin
false
1
Polygon -16777216 true false 262 116 229 84 199 84 169 114 124 114 99 126 93 132 89 141 81 146 80 154 44 160 74 171 49 189 124 204 184 189 214 174 229 129
Circle -955883 true false 215 96 14
Polygon -2674135 true true 223 130 184 128 154 143 134 162 124 178 119 194 118 205 140 203 182 191 211 178 226 140 227 130

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

smallbug
true
0
Circle -7500403 true true 133 144 34
Circle -7500403 true true 137 123 26
Circle -7500403 true true 140 105 20
Line -7500403 true 150 115 105 75
Line -7500403 true 150 115 195 76

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

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
0
@#$#@#$#@
