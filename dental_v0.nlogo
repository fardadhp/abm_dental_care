breed [people person]
breed [clinics clinic]

people-own [
  income          ;; income class: 0=unemployed; 1=low-income; 2=high-income
  age             ;; 1= 0-17 ; 2= 18-64 ; 3= +65
  working-hours   ;; 0=not working; 1=day shift (8am-5pm); 2=night shift (9pm-6am)
  off-day         ;; 0=employed individual cannot take a day off to visit a dentist; 1=he/she can
  insurance       ;; 0=no insurance; 1=with dental insurance
  knowledge       ;; 0=no knowledge about available low-cost or free dental services; 1=with knowledge
  awareness       ;; 0=not aware of the benefits of routine dental care; 1=aware
  max-travel-distance  ;; maximum distance the person is willing or can afford to travel to get to clinics [km]
  network          ;; network of family and friends (list of IDs)
  acceptable-wait-time    ;; maximum time the person is willing to wait for an appointment (acceptable appointment wait time) [days]
  dental-need      ;; 0=basic (filling, cleaning ...); 1=advanced (root canal, surgery ...)
  area             ;; neighborhood
  acceptability    ;; {0,1}
  accessibility    ;; {0,1}
  affordability    ;; {0,1}
  accomodation     ;; {0,1}
  availability     ;; {0,1}
  a5               ;; 5-A scores for clinics
  covered?         ;; 0=no; 1=yes
  my-clinic        ;; ID of the clinic the person visits; if none, set to nobody
]

clinics-own [
  category         ;; 0=dental clinic; 1=low-cost clinic; 2=mobile clinic
  patients         ;; ID of patients who visit the clinic
  services         ;; available dental services: 0=basic (filling, cleaning ...); 1=advanced (root canal, surgery ...)
  operating-hours  ;; 0=daytime (8am-5pm); 1=daytime+evening (8am-10pm)
  average-wait-time   ;; average-appointment-wait-time [days]
  free-transport   ;; 0=not availabel; 1=available
  free-transport-radius   ;; distance from the clinic for which free tranport service is available
  areac            ;; neighborhood

]

patches-own [
  neighborhood
]

globals [
  na
  nb
  nc
  nd
  network-size
  covered_A
  covered_B
  covered_C
  covered_D
  covered_A_i0i0
  covered_A_i1i0
  covered_A_i1i1
  covered_B_i0i0
  covered_B_i1i0
  covered_B_i1i1
  covered_C_i0i0
  covered_C_i1i0
  covered_C_i1i1
  covered_D_i0i0
  covered_D_i1i0
  covered_D_i1i1
]

to setup
  ct
  clear-all
  reset-ticks
  resize-world -20 19 -20 19

  set network-size 5

  set na patches with [pxcor >= 0 and pycor >= 0]
  set nb patches with [pxcor < 0 and pycor >= 0]
  set nc patches with [pxcor < 0 and pycor < 0]
  set nd patches with [pxcor >= 0 and pycor < 0]
  ask na [set pcolor 105 set neighborhood "A"]
  ask nb [set pcolor 106 set neighborhood "B"]
  ask nc [set pcolor 107 set neighborhood "C"]
  ask nd [set pcolor 108 set neighborhood "D"]

  make-people
  make-clinics
  set-scenario
end

to make-people
  create-people population_A [
    move-to one-of na with [not any? people-here]
    set area "A"
  ]
  create-people population_B [
    move-to one-of nb with [not any? people-here]
    set area "B"
  ]
  create-people population_C [
    move-to one-of nc with [not any? people-here]
    set area "C"
  ]
  create-people population_D [
    move-to one-of nd with [not any? people-here]
    set area "D"
  ]

  ask people [
    set shape "person"
    set color black
    set size 0.75
    set income 0
    set age 0
    set working-hours 1
    set off-day 1
    set insurance 0
    set knowledge 0
    set awareness 0
    set network n-of network-size people with [neighborhood = [neighborhood] of myself and self != myself]
    set acceptable-wait-time (10 + random 10)
    set dental-need 0
    set my-clinic nobody
    set acceptability 0
    set accessibility 0
    set affordability 0
    set accomodation 0
    set availability 0
    set covered? 0
    set a5 []
  ]
end

to make-clinics
  create-clinics num_clinics_A [
    move-to one-of na with [not any? people-here and not any? clinics-here]
    set category 0
    set areac "A"
  ]
  create-clinics num_clinics_B [
    move-to one-of nb with [not any? people-here and not any? clinics-here]
    set category 0
    set areac "B"
  ]
  create-clinics num_clinics_C [
    move-to one-of nc with [not any? people-here and not any? clinics-here]
    set category 0
    set areac "C"
  ]
  create-clinics num_clinics_D [
    move-to one-of nd with [not any? people-here and not any? clinics-here]
    set category 0
    set areac "D"
  ]
  create-clinics num_low_cost_clinics_A [
    move-to one-of na with [not any? people-here and not any? clinics-here]
    set category 1
    set areac "A"
  ]
  create-clinics num_low_cost_clinics_B [
    move-to one-of nb with [not any? people-here and not any? clinics-here]
    set category 1
    set areac "B"
  ]
  create-clinics num_low_cost_clinics_C [
    move-to one-of nc with [not any? people-here and not any? clinics-here]
    set category 1
    set areac "C"
  ]
  create-clinics num_low_cost_clinics_D [
    move-to one-of nd with [not any? people-here and not any? clinics-here]
    set category 1
    set areac "D"
  ]
  if mobile_clinic_A_random_location? and num_mobile_clinics_A > 0 [
    create-clinics num_mobile_clinics_A [
      move-to one-of na with [not any? people-here and not any? clinics-here]
      set category 2
      set areac "A"
    ]
  ]
  if mobile_clinic_B_random_location? and num_mobile_clinics_B > 0 [
    create-clinics num_mobile_clinics_B [
      move-to one-of nb with [not any? people-here and not any? clinics-here]
      set category 2
      set areac "B"
    ]
  ]
  if mobile_clinic_C_random_location? and num_mobile_clinics_C > 0 [
    create-clinics num_mobile_clinics_C [
      move-to one-of nc with [not any? people-here and not any? clinics-here]
      set category 2
      set areac "C"
    ]
  ]
  if mobile_clinic_D_random_location? and num_mobile_clinics_D > 0 [
    create-clinics num_mobile_clinics_D [
      move-to one-of nd with [not any? people-here and not any? clinics-here]
      set category 2
      set areac "D"
    ]
  ]
  ask clinics [
    set shape "box"
    set color green
    set size 0.75
    set patients nobody
    set services 1
    set operating-hours 0
    set average-wait-time random 20
    set free-transport 0
    set free-transport-radius 10
  ]
end


to Locate_A
  ifelse not mobile_clinic_A_random_location? and count (clinics with [category = 2 and areac = "A"]) < num_mobile_clinics_A [
    if mouse-down? and [neighborhood] of (patch mouse-xcor mouse-ycor) = "A"  [
      ask patch mouse-xcor mouse-ycor [
        sprout-clinics 1 [
          set category 2
          set areac "A"
          set shape "box"
          set color green
          set size 0.75
          set patients nobody
          set services 1
          set operating-hours 0
          set average-wait-time (5 + random 10)
          set free-transport 0
        ]
      ]
      stop
    ]
  ]
  [
    user-message "All mobile clinics are located."
    stop
  ]
end

to Locate_B
  ifelse not mobile_clinic_B_random_location? and count (clinics with [category = 2 and areac = "B"]) < num_mobile_clinics_B [
    if mouse-down? and [neighborhood] of (patch mouse-xcor mouse-ycor) = "B"  [
      ask patch mouse-xcor mouse-ycor [
        sprout-clinics 1 [
          set category 2
          set areac "B"
          set shape "box"
          set color green
          set size 0.75
          set patients nobody
          set services 1
          set operating-hours 0
          set average-wait-time (5 + random 10)
          set free-transport 0
        ]
      ]
      stop
    ]
  ]
  [
    user-message "All mobile clinics are located."
    stop
  ]
end

to Locate_C
  ifelse not mobile_clinic_C_random_location? and count (clinics with [category = 2 and areac = "C"]) < num_mobile_clinics_C [
    if mouse-down? and [neighborhood] of (patch mouse-xcor mouse-ycor) = "C"  [
      ask patch mouse-xcor mouse-ycor [
        sprout-clinics 1 [
          set category 2
          set areac "C"
          set shape "box"
          set color green
          set size 0.75
          set patients nobody
          set services 1
          set operating-hours 0
          set average-wait-time (5 + random 10)
          set free-transport 0
        ]
      ]
      stop
    ]
  ]
  [
    user-message "All mobile clinics are located."
    stop
  ]
end

to Locate_D
  ifelse not mobile_clinic_D_random_location? and count (clinics with [category = 2 and areac = "D"]) < num_mobile_clinics_D [
    if mouse-down? and [neighborhood] of (patch mouse-xcor mouse-ycor) = "D"  [
      ask patch mouse-xcor mouse-ycor [
        sprout-clinics 1 [
          set category 2
          set areac "D"
          set shape "box"
          set color green
          set size 0.75
          set patients nobody
          set services 1
          set operating-hours 0
          set average-wait-time (5 + random 10)
          set free-transport 0
        ]
      ]
      stop
    ]
  ]
  [
    user-message "All mobile clinics are located."
    stop
  ]
end

to set-scenario
  let p1 n-of (round (0.8 * population_A)) people with [area = "A"]
  let p2 n-of (round (0.8 * population_B)) people with [area = "B"]
  let p3 n-of (round (0.8 * population_C)) people with [area = "C"]
  let p4 n-of (round (0.8 * population_D)) people with [area = "D"]
  let p (turtle-set p1 p2 p3 p4)
  ask p [
    set knowledge 1
    set awareness 1
    set acceptability 1
  ]
  ask n-of round (0.8 * population_A) people with [area = "A"] [set income 1]
  ask n-of round (0.8 * population_B) people with [area = "B"] [set income 1]
  ask n-of round (0.8 * population_C) people with [area = "C"] [set income 1]
  ask n-of round (0.8 * population_D) people with [area = "D"] [set income 1]

  let wpa count people with [area = "A" and income > 0]
  let wpb count people with [area = "B" and income > 0]
  let wpc count people with [area = "C" and income > 0]
  let wpd count people with [area = "D" and income > 0]

  ask n-of round (0.1 * wpa) people with [area = "A" and income > 0] [set working-hours 2]
  ask n-of round (0.1 * wpb) people with [area = "B" and income > 0] [set working-hours 2]
  ask n-of round (0.1 * wpc) people with [area = "C" and income > 0] [set working-hours 2]
  ask n-of round (0.1 * wpd) people with [area = "D" and income > 0] [set working-hours 2]

  ask n-of round (0.25 * wpa) people with [area = "A" and income > 0] [set off-day 0]
  ask n-of round (0.25 * wpb) people with [area = "B" and income > 0] [set off-day 0]
  ask n-of round (0.25 * wpc) people with [area = "C" and income > 0] [set off-day 0]
  ask n-of round (0.25 * wpd) people with [area = "D" and income > 0] [set off-day 0]

  ask n-of round (0.75 * wpa) people with [area = "A" and income = 1] [set insurance 1]
  ask n-of round (0.75 * wpb) people with [area = "B" and income = 1] [set insurance 1]
  ask n-of round (0.75 * wpc) people with [area = "C" and income = 1] [set insurance 1]
  ask n-of round (0.75 * wpd) people with [area = "D" and income = 1] [set insurance 1]

  ask n-of (round (0.2 * population_A)) people with [area = "A"] [set age 1]
  ask n-of (round (0.1 * population_A)) people with [area = "A" and age != 1] [set age 3]
  ask people with [area = "A" and age = 0] [set age 2]
  ask n-of (round (0.2 * population_B)) people with [area = "B"] [set age 1]
  ask n-of (round (0.1 * population_B)) people with [area = "B" and age != 1] [set age 3]
  ask people with [area = "B" and age = 0] [set age 2]
  ask n-of (round (0.2 * population_C)) people with [area = "C"] [set age 1]
  ask n-of (round (0.1 * population_C)) people with [area = "C" and age != 1] [set age 3]
  ask people with [area = "C" and age = 0] [set age 2]
  ask n-of (round (0.2 * population_D)) people with [area = "D"] [set age 1]
  ask n-of (round (0.1 * population_D)) people with [area = "D" and age != 1] [set age 3]
  ask people with [area = "D" and age = 0] [set age 2]
  ask people [
    ifelse income = 0 [
      set max-travel-distance 6
      set working-hours 0
    ]
    [
      set max-travel-distance 10
    ]
  ]

  if scenario = 1 []
  if scenario = 2 [
    ask people with [area = "B"] [set income 0 set insurance 0 set max-travel-distance 6 set working-hours 0]
    ask people with [area = "C"] [set income 1 set insurance 0 set max-travel-distance 10]
    ask people with [area = "D"] [set income 1 set insurance 1 set max-travel-distance 10]
  ]
  if scenario = 3 [
    ask people [set acceptability 0]
    ask people with [area = "A"] [set acceptability 1]
    ask n-of (0.75 * population_B) (people with [area = "B"]) [set acceptability 1]
    ask n-of (0.5 * population_C) (people with [area = "C"]) [set acceptability 1]
    ask n-of (0.25 * population_D) (people with [area = "D"]) [set acceptability 1]
  ]
  if scenario = 4 [
    ask people with [area != "A"] [set age 1]
    ask n-of (0.2 * population_B) people with [area = "B"] [set age 2]
    ask n-of (0.2 * population_B) people with [area = "B" and age = 1] [set age 3]
    ask n-of (0.6 * population_C) people with [area = "C"] [set age 2]
    ask n-of (0.2 * population_C) people with [area = "C" and age = 1] [set age 3]
    ask n-of (0.2 * population_D) people with [area = "D"] [set age 2]
    ask n-of (0.6 * population_D) people with [area = "D" and age = 1] [set age 3]
  ]
  if scenario = 5 [
    ask people with [area = "B"] [set max-travel-distance (max-travel-distance * 0.5)]
    ask people with [area = "C"] [set max-travel-distance (max-travel-distance * 2)]
    ask people with [area = "D"] [set max-travel-distance (max-travel-distance * 3)]
  ]
  if scenario = 6 [
    ask clinics [die]
    set num_low_cost_clinics_A 6
    set num_low_cost_clinics_B 4
    set num_low_cost_clinics_C 2
    set num_low_cost_clinics_D 0
    make-clinics
  ]
  if scenario = 7 [
    ask clinics [die]
    set num_mobile_clinics_A 6
    set num_mobile_clinics_B 4
    set num_mobile_clinics_C 2
    set num_mobile_clinics_D 0
    make-clinics
  ]
  if scenario = 8 [
    ask clinics with [areac = "A"] [set operating-hours 1]
  ]
  if scenario = 9 [
    ask clinics with [areac = "A"] [set average-wait-time (average-wait-time / 2)]
  ]
  if scenario = 10 [
    ask clinics with [areac = "B" and category != 2] [set free-transport 1]
    ask clinics with [areac = "C" and category != 2] [set free-transport 1 set free-transport-radius (free-transport-radius * 2)]
    ask clinics with [areac = "D" and category != 2] [set free-transport 1 set free-transport-radius (free-transport-radius * 3)]
  ]

end

to go
  ask people [
    ifelse acceptability = 0 [set covered? 0] [
      let options clinics
      ifelse not any? options [set covered? 0] [
        set options sort clinics
        foreach options [cln ->
          set accessibility 0
          set affordability 0
          set availability 0
          set accomodation 0
          ;accessibility
          if distance2v patch-here cln <= max-travel-distance or (distance2v patch-here cln <= ([free-transport-radius] of cln) and ([free-transport] of cln) = 1) [set accessibility 1]
          ;affordability
          ifelse insurance = 1 [
            set affordability 1
          ]
          [
            ifelse [category] of cln = 0 and (age = 1 or age = 3) [
              set affordability 1
            ]
            [
              ifelse [category] of cln = 1 and income > 0 [
                set affordability 1
              ]
              [
                if [category] of cln = 2 [
                  set affordability 1
                ]
              ]
            ]
          ]
          ;availability
          if dental-need <= [services] of cln and acceptable-wait-time >= [average-wait-time] of cln [set availability 1]
          ;accomodation
          if working-hours = 0 or off-day = 1 or working-hours + [operating-hours] of cln != 1 [set accomodation 1]
          ;
          set a5 lput (list ([who] of cln) accessibility affordability availability accomodation) a5
          let score accessibility * affordability * availability * accomodation
          if score = 1 [
            ifelse covered? = 0 [
              set covered? 1
              set my-clinic cln
            ]
            [
              if distance2v patch-here cln < distance2v patch-here my-clinic [set my-clinic cln]
            ]
          ]
        ]
      ]
    ]
  ]
  set covered_A (count people with [area = "A" and covered? = 1]) / (count people with [area = "A"]) * 100
  set covered_B (count people with [area = "B" and covered? = 1]) / (count people with [area = "B"]) * 100
  set covered_C (count people with [area = "C" and covered? = 1]) / (count people with [area = "C"]) * 100
  set covered_D (count people with [area = "D" and covered? = 1]) / (count people with [area = "D"]) * 100
  carefully [set covered_A_i0i0 (count people with [area = "A" and covered? = 1 and income = 0 and insurance = 0]) / (count people with [area = "A" and income = 0 and insurance = 0]) * 100] [set covered_A_i0i0 0]
  carefully [set covered_A_i1i0 (count people with [area = "A" and covered? = 1 and income = 1 and insurance = 0]) / (count people with [area = "A" and income = 1 and insurance = 0]) * 100] [set covered_A_i1i0 0]
  carefully [set covered_A_i1i1 (count people with [area = "A" and covered? = 1 and income = 1 and insurance = 1]) / (count people with [area = "A" and income = 1 and insurance = 1]) * 100] [set covered_A_i1i1 0]
  carefully [set covered_B_i0i0 (count people with [area = "B" and covered? = 1 and income = 0 and insurance = 0]) / (count people with [area = "B" and income = 0 and insurance = 0]) * 100] [set covered_B_i0i0 0]
  carefully [set covered_B_i1i0 (count people with [area = "B" and covered? = 1 and income = 1 and insurance = 0]) / (count people with [area = "B" and income = 1 and insurance = 0]) * 100] [set covered_B_i1i0 0]
  carefully [set covered_B_i1i1 (count people with [area = "B" and covered? = 1 and income = 1 and insurance = 1]) / (count people with [area = "B" and income = 1 and insurance = 1]) * 100] [set covered_B_i1i1 0]
  carefully [set covered_C_i0i0 (count people with [area = "C" and covered? = 1 and income = 0 and insurance = 0]) / (count people with [area = "C" and income = 0 and insurance = 0]) * 100] [set covered_C_i0i0 0]
  carefully [set covered_C_i1i0 (count people with [area = "C" and covered? = 1 and income = 1 and insurance = 0]) / (count people with [area = "C" and income = 1 and insurance = 0]) * 100] [set covered_C_i1i0 0]
  carefully [set covered_C_i1i1 (count people with [area = "C" and covered? = 1 and income = 1 and insurance = 1]) / (count people with [area = "C" and income = 1 and insurance = 1]) * 100] [set covered_C_i1i1 0]
  carefully [set covered_D_i0i0 (count people with [area = "D" and covered? = 1 and income = 0 and insurance = 0]) / (count people with [area = "D" and income = 0 and insurance = 0]) * 100] [set covered_D_i0i0 0]
  carefully [set covered_D_i1i0 (count people with [area = "D" and covered? = 1 and income = 1 and insurance = 0]) / (count people with [area = "D" and income = 1 and insurance = 0]) * 100] [set covered_D_i1i0 0]
  carefully [set covered_D_i1i1 (count people with [area = "D" and covered? = 1 and income = 1 and insurance = 1]) / (count people with [area = "D" and income = 1 and insurance = 1]) * 100] [set covered_D_i1i1 0]
  tick
end


to-report distance2v [agent1 agent2]
  let xx1 0 let xx2 0 let yy1 0 let yy2 0
  ifelse is-turtle? agent1 [
    set xx1 [xcor] of agent1
    set yy1 [ycor] of agent1
  ]
  [
    ifelse is-patch? agent1 [
      set xx1 [pxcor] of agent1
      set yy1 [pycor] of agent1
    ]
    [
      set xx1 item 0 agent1
      set yy1 item 1 agent1
    ]
  ]
  ifelse is-turtle? agent2 [
    set xx2 [xcor] of agent2
    set yy2 [ycor] of agent2
  ]
  [
    ifelse is-patch? agent2 [
      set xx2 [pxcor] of agent2
      set yy2 [pycor] of agent2
    ]
    [
      set xx2 item 0 agent2
      set yy2 item 1 agent2
    ]
  ]
  report sqrt ((xx1 - xx2) ^ 2 + (yy1 - yy2) ^ 2)
end
@#$#@#$#@
GRAPHICS-WINDOW
927
54
1735
863
-1
-1
20.0
1
10
1
1
1
0
0
0
1
-20
19
-20
19
0
0
1
ticks
30.0

BUTTON
21
369
84
402
NIL
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

TEXTBOX
1540
23
1690
42
Neighborhood A
15
0.0
1

TEXTBOX
1079
23
1229
42
Neighborhood B
15
0.0
1

TEXTBOX
1107
928
1257
947
Neighborhood C
15
0.0
1

TEXTBOX
1526
925
1676
944
Neighborhood D
15
0.0
1

INPUTBOX
18
28
97
88
population_A
100.0
1
0
Number

INPUTBOX
19
97
98
157
population_B
100.0
1
0
Number

INPUTBOX
19
166
99
226
population_C
100.0
1
0
Number

INPUTBOX
20
236
100
296
population_D
100.0
1
0
Number

INPUTBOX
119
29
206
89
num_clinics_A
2.0
1
0
Number

INPUTBOX
120
97
207
157
num_clinics_b
2.0
1
0
Number

INPUTBOX
120
166
208
226
num_clinics_C
2.0
1
0
Number

INPUTBOX
120
236
209
296
num_clinics_D
2.0
1
0
Number

INPUTBOX
225
29
360
89
num_low_cost_clinics_A
1.0
1
0
Number

INPUTBOX
226
99
362
159
num_low_cost_clinics_B
1.0
1
0
Number

INPUTBOX
226
167
362
227
num_low_cost_clinics_C
1.0
1
0
Number

INPUTBOX
227
236
363
296
num_low_cost_clinics_D
1.0
1
0
Number

INPUTBOX
371
30
497
90
num_mobile_clinics_A
0.0
1
0
Number

INPUTBOX
371
100
498
160
num_mobile_clinics_B
0.0
1
0
Number

INPUTBOX
372
168
500
228
num_mobile_clinics_C
0.0
1
0
Number

INPUTBOX
373
237
500
297
num_mobile_clinics_D
0.0
1
0
Number

SWITCH
511
30
727
63
mobile_clinic_A_random_location?
mobile_clinic_A_random_location?
0
1
-1000

SWITCH
510
100
728
133
mobile_clinic_B_random_location?
mobile_clinic_B_random_location?
0
1
-1000

SWITCH
510
169
730
202
mobile_clinic_C_random_location?
mobile_clinic_C_random_location?
0
1
-1000

SWITCH
511
238
728
271
mobile_clinic_D_random_location?
mobile_clinic_D_random_location?
0
1
-1000

BUTTON
775
28
858
61
NIL
Locate_A
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
776
99
858
132
NIL
Locate_B
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
776
168
859
201
NIL
Locate_C
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
777
238
860
271
NIL
Locate_D
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
746
33
774
54
or
15
0.0
1

TEXTBOX
745
104
760
123
or
15
0.0
1

TEXTBOX
747
174
762
193
or
15
0.0
1

TEXTBOX
747
245
762
264
or
15
0.0
1

CHOOSER
20
314
112
359
scenario
scenario
1 2 3 4 5 6 7 8 9 10
0

BUTTON
21
414
84
447
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
739
326
908
371
covered population in A (%)
(count people with [area = \"A\" and covered? = 1]) / (count people with [area = \"A\"]) * 100
0
1
11

MONITOR
740
375
911
420
covered population in B (%)
(count people with [area = \"B\" and covered? = 1]) / (count people with [area = \"B\"]) * 100
0
1
11

MONITOR
741
424
910
469
covered population in C (%)
(count people with [area = \"C\" and covered? = 1]) / (count people with [area = \"C\"]) * 100
0
1
11

MONITOR
741
472
910
517
covered population in D (%)
(count people with [area = \"D\" and covered? = 1]) / (count people with [area = \"D\"]) * 100
0
1
11

TEXTBOX
169
323
705
494
Instructions:\n1) Set population in each neighborhood.\n2) Set number of clinics (public, low-cost, and mobile) in each neighborhood. \n3) Set mobile clinics to be randomly located over neighborhood A or to manualy locate the mobile clinic, click on \"Locate_A\" and then click on an empty spot on neighborhood A (repeat for other neighborhoods).\n4) Select scenario.\n5) Click on the \"setup\" button.\n6) Click on the \"go\" button.
14
0.0
1

BUTTON
20
495
155
528
show family network
ask people [\ncreate-links-with network\n]\nask links [set color red]\n;wait 5\n;ask links [set hidden? true die]
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
185
495
366
528
show patient-clinic network
ask people [\nif my-clinic != nobody [\ncreate-links-with turtle-set my-clinic\n]\n]\nask links [set color red]\n;wait 5\n;ask links [set hidden? true die]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
455
434
723
584
% population covered by dental services
     A                  B                  C                D
% covered
0.0
4.0
0.0
100.0
false
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "plotxy 0 ((count people with [area = \"A\" and covered? = 1]) / (count people with [area = \"A\"]) * 100)"
"pen-1" 1.0 1 -16777216 true "" "plotxy 1 ((count people with [area = \"B\" and covered? = 1]) / (count people with [area = \"B\"]) * 100)"
"pen-2" 1.0 1 -16777216 true "" "plotxy 2 ((count people with [area = \"C\" and covered? = 1]) / (count people with [area = \"C\"]) * 100)"
"pen-3" 1.0 1 -16777216 true "" "plotxy 3 ((count people with [area = \"D\" and covered? = 1]) / (count people with [area = \"D\"]) * 100)"

BUTTON
127
546
212
579
clear links
ask links [die]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go
stop</go>
    <metric>covered_A</metric>
    <metric>covered_B</metric>
    <metric>covered_C</metric>
    <metric>covered_D</metric>
    <metric>covered_A_i0i0</metric>
    <metric>covered_A_i1i0</metric>
    <metric>covered_A_i1i1</metric>
    <metric>covered_B_i0i0</metric>
    <metric>covered_B_i1i0</metric>
    <metric>covered_B_i1i1</metric>
    <metric>covered_C_i0i0</metric>
    <metric>covered_C_i1i0</metric>
    <metric>covered_C_i1i1</metric>
    <metric>covered_D_i0i0</metric>
    <metric>covered_D_i1i0</metric>
    <metric>covered_D_i1i1</metric>
    <enumeratedValueSet variable="population_D">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_clinics_b">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_mobile_clinics_D">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_clinics_A">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mobile_clinic_C_random_location?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population_A">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mobile_clinic_A_random_location?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_low_cost_clinics_A">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population_B">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_low_cost_clinics_B">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_mobile_clinics_A">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_clinics_C">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_low_cost_clinics_C">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_mobile_clinics_B">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_clinics_D">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_mobile_clinics_C">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mobile_clinic_D_random_location?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num_low_cost_clinics_D">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="population_C">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="scenario" first="1" step="1" last="10"/>
    <enumeratedValueSet variable="mobile_clinic_B_random_location?">
      <value value="true"/>
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
0
@#$#@#$#@
