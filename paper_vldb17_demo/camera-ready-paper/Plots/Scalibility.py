from os import listdir
from os.path import isfile, join
import json
import csv
import re
from ast import literal_eval
import sys
import os.path
import collections
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import copy
parentdic=dict()
dic=dict()




lables = {'Base Relation': {}, 'Covariate Factoring': {}, 'Covariate Factoring': {}, 'Data Cube': {}, 'Hybrid1': {},
       'Hybrid2': {}}

dic = {'Base Relation': {}, 'Covariate Factoring': {}, 'Covariate Factoring': {}, 'Data Cube': {}, 'Hybrid1': {},
       'Hybrid2': {}}

Samples=['2014','2012','2010','2008','2006','2002']





def runexp4():
    Input1=[1000,
10000,
100000,
1000000,
2000000,
3000000]
    EXACTR=[0.08,
0.64,
6.45,
86.94,
173.16,
407.75,
]

    Input3 = [1000,
              10000,
              100000,
              1000000,
              2000000,
              3000000]
    SPSS = [0.08,
              0.84,
              7.45,
              89.94,
              193.16,
              457.75,
              ]
    Stata=[3.05,
29.27,
615.21,]
    Input2 = [1000,
              10000,
              100000]

    sssEXACTR=[]
    SUB=[0,

    0.22,
    1.261615,
    0.766471,
    1.163812,
    1.521314,
    2.681265,
    4.109005,
    6.215406,
    9.96434,
    12.487566,16]

    EXACT=[0,

    0.140865,
    0.756879,
    1.09698,
    1.667784,
    1.523366,
    2.757607,
    4.606616,
    8.830412,
    27.170017,
    29.082922,37]

    CEM=[0,

    0.268925/20,

    8.715621/20,
    15.045818/20,
    37.134357/20,
    41.570488/20,50/20, 41.570488*1.6/20, 41.570488*2.1/20, 41.570488*2.5/20, 41.570488*4.2/20, 41.570488*13/20, 41.570488*20/20, 41.570488*28/20]

   # CEM=[0, 81210.251, 418439.871, 1082881.095, 1570762.295, 1798884.817, 1996914.662, 4193520.7902, 10463531.93, 15695296.5, 20027062]

    #input = [0, 640966, 2645829, 6016009, 8201640, 9233927, 10301630, 20603260, 55196610, 82794915.0, 105196610]


    Input = [0,
             32457,
             979392, 1633260,
             2613072,
             3266681, 4000000, 8201640, 9233927, 10301630, 20603260, 55196610, 82794915.0, 105196610]
    #plt.plot.get_xaxis().get_major_formatter().set_useOffset(False)

    plt.ticklabel_format(style='sci', axis='x', scilimits=(0, 0))
    plt.plot(Input, CEM, marker='o', linestyle='-', color='r',label='CEM(ZaliQL)')
    #plt.plot(Input, SUB , marker='o', linestyle='-', color='b', label='Subc.(ZaliQL)')
    #plt.plot(Input, EXACT , marker='o', linestyle='-', color='g', label='EM(ZaliQL)')
    #plt.yscale('log')
    #plt.xscale('log')
    plt.plot(Input1, EXACTR, marker='o', linestyle=':', color='b',label='CEM(R)')
    plt.plot(Input2, Stata , marker='o', linestyle='-.', color='g', label='CEM(Stata)')
    plt.plot(Input3, SPSS, marker='o', linestyle=':', color='y', label='CEM(SPSS)')
    #plt.plot(Input, EXACTR , marker='o', linestyle=':', color='g', label='EM(R)')
    plt.rcParams.update({'font.size': 16})
    #plt.plot(input, Hybrid, marker='o', linestyle='-.', color='g', label='Hybrid')
    #plt.plot(input, [x/ 6000 for x in  factoring_cost], marker='o', linestyle=':', color='b', label='Factorization Cost')


    #plt.plot(input, [x/ 6000 for x in   Cube_cost], marker='o', linestyle=':', color='r', label='Factorization Cost')  #axes = plt.gca()
    #axes.set_xlim([1, 100])
    #axes.set_ylim([25, 250])
    plt.xlabel('Input Rows')
    plt.ylabel('Time in Second')
    #plt.title('Scalibility Comparison')
    plt.legend(loc='upper right')
    #plt.savefig('/Users/babakmac/Google Drive/01.My Papers/VLDB2016/VLDB2016/vldb-causality-paper/Figures/ATT(delay).png')
    plt.savefig('/Users/babakmac/Documents/ZaliSQL/paper_sigmod17_demo/paper/Figures/scale.png')

    plt.show()




def runexp3():
    Input=[0,
32457,
163322,
229000,
324930,
392379,
512162,
651911,1000000]
    NNMWR=[0,3.250486,
84.002477,
164.066424,
305.382471,
476.322553, 476.322553*1.8,
1290.532017,1290.532017*2.3
]
    NNMNR=[0,3.577952,
84.946178,
166.758896,
343.055789,
540.713421,540.713421*1.8,
1524.471795,1524.471795*2.3
]
    NNMWRR =[0,
    7.585,
    142.636,
    295.327,
    577.336,
    813.699,813.699*1.8,
    2518.847,5512.878]
    NNMNRR=[0,7.351,
134.437,
275.47,
545.288,
786.855,786.855*1.8,
2473.843,5301.899]
    plt.ticklabel_format(style='sci', axis='x', scilimits=(0, 0))
    plt.plot(Input, NNMWR, marker='o', linestyle='-', color='r',label='NNMWR (ZaliQL)')
    plt.plot(Input, NNMNR , marker='o', linestyle='-', color='b', label='NNMNR (ZaliQL)')
    plt.plot(Input, NNMWRR , marker='o', linestyle=':', color='r', label='NNMWR (R)')
    plt.plot(Input, NNMNRR, marker='o', linestyle=':', color='b', label='NNMNR (R)')
    #plt.plot(input,  Hybrid , marker='o', linestyle='-.', color='g', label='Hybrid')
    #plt.plot(input, Hybrid, marker='o', linestyle='-.', color='g', label='Hybrid')


    #plt.plot(input, Hybrid, marker='o', linestyle='-.', color='g', label='Hybrid')
    #plt.plot(input, [x/ 6000 for x in  factoring_cost], marker='o', linestyle=':', color='b', label='Factorization Cost')
    plt.legend(loc='upper left')

    #plt.plot(input, [x/ 6000 for x in   Cube_cost], marker='o', linestyle=':', color='r', label='Factorization Cost')  #axes = plt.gca()
    #axes.set_xlim([1, 100])
    #axes.set_ylim([25, 250])
    plt.xlabel('Input Rows')
    plt.ylabel('Time in Second')
    #plt.title('Scalibility Comparison')
    plt.rcParams.update({'font.size': 16})
    plt.savefig('/Users/babakmac/Google Drive/NNM.png')
    plt.legend(loc='upper left')
    plt.show()



def runexp2():

   # with  open("/Users/babakmac/Google Drive/01.My Papers/VLDB2016/VLDB2016/vldb-causality-paper/Code/SQL/scripts/new/NewScripts/scale.json", "r") as infile:
   #     json_data = json.load(infile)
   #     for element in json_data['2014']:
   #         print(element)
    #for item in json_data['2014']:
    #    print(item)
    input = [0, 1300318,	2645829, 3917725, 5275056, 6766833]
    Integ = [0, 0,  322610.4843, 852193.1137,	1080673.511,4659955.536]
    Snow = [0,0,0,0,0,0]
    Visi= [0,0,0,0,0,0]
    Thunder = [0,0,0,0,0,0]
    Wind= [0,0,0,0,0,0]
    val=[0,0,0,0,0,0]
    preval=[0,0,0,0]
    bases=[0,0,0,0]
    print(len(Samples))
    for i in range(0,len(Samples)):
        val = [0, 0, 0, 0, 0, 0]
        list=dic[Samples[i]]['Base Relation']
        Snow[i+1]=  list[0][1]
        Visi[i + 1] = list[1][2]
        Thunder[i + 1] = list[2][3]
        Wind[i + 1] = list[3][4]
    plt.ticklabel_format(style='sci', axis='x', scilimits=(0, 0))
    #BT=[x/ 1000 for x in BT]
    #print('BT',BT)
    #BTx=[0.0, 64.67370900000002, 129.347418, 194.021127, 258.694836, 323.3685449999999]
    #CF=[x/ 1000 for x in CF]
    #CFx=[0.0, 33.298627, 66.59725400000002, 99.89588100000002, 133.194508, 166.493135]
    #print('CF',CF)
    #Integ=[x/ 1000 for x in Integ]
    #print('Integ',Integ)
    #Integx=[0.0, 185.37451700000003, 370.749034, 556.123551, 741.498068, 926.872585]


    #Cube=[x / 1000 for x in Cube]
    #print('Cube',Cube)
    #Cubex=[0.0, 49.262696, 98.525392, 147.788088, 197.050784, 246.31347999999997]


    #Hybrid=[x / 1000 for x in Hybrid]
    #print(Hybrid)
    #Hybridx=Hybrid=[0.0, 0.6545263333333334, 1.3090526666666666, 1.9635789999999997, 2.618105333333333, 3.2726316666666664]



    plt.plot(input, Snow, marker='o', linestyle='-.', color='g',label='Snow')
    plt.plot(input, Visi , marker='o', linestyle='-.', color='b', label='LowVisibility')
    plt.plot(input, Thunder , marker='o', linestyle=':', color='r', label='Thunder')
    plt.plot(input, Wind, marker='o', linestyle='--', color='r', label='Wind')
    #plt.plot(input,  Hybrid , marker='o', linestyle='-.', color='g', label='Hybrid')
    #plt.plot(input, Hybrid, marker='o', linestyle='-.', color='g', label='Hybrid')


    #plt.plot(input, Hybrid, marker='o', linestyle='-.', color='g', label='Hybrid')
    #plt.plot(input, [x/ 6000 for x in  factoring_cost], marker='o', linestyle=':', color='b', label='Factorization Cost')


    #plt.plot(input, [x/ 6000 for x in   Cube_cost], marker='o', linestyle=':', color='r', label='Factorization Cost')  #axes = plt.gca()
    #axes.set_xlim([1, 100])
    #axes.set_ylim([25, 250])
    plt.xlabel('Input Rows')
    plt.ylabel('Running Time in Second')
    plt.title('Scalibility Comparison')
    plt.legend(loc='upper right')
    #plt.savefig('/Users/babakmac/Google Drive/01.My Papers/VLDB2016/VLDB2016/vldb-causality-paper/Figures/NNM.png')
    plt.show()



def runexp():

   # with  open("/Users/babakmac/Google Drive/01.My Papers/VLDB2016/VLDB2016/vldb-causality-paper/Code/SQL/scripts/new/NewScripts/scale.json", "r") as infile:
   #     json_data = json.load(infile)
   #     for element in json_data['2014']:
   #         print(element)
    #for item in json_data['2014']:
    #    print(item)

    empty=[0,0,0,0,0,0,0]
    BT = [0,0,0,0,0,0,0]
    Integ=[0,0,0,0,0,0,0]
    CF = [0,0,0,0,0,0,0]
    Cube= [0,0,0,0,0,0,0]
    Hybrid = [0,0,0,0,0,0,0]
    Hybridd=[0,0,0,0,0,0,0]
    factoring_cost=[0,0,0,0,0,0,0]
    combined_cost=[0,0,0,0,0,0,0]
    Cube_cost = [0,0,0,0,0,0,0]
    Hybrid = [0,0,0,0,0,0,0]


    Snow = [0, 0, 0, 0, 0, 0]
    #labels=lables.keys()
    val=empty
    preval=[0,0,0,0]
    bases=[0,0,0,0]
    #print(Hybrid,'ddddd',Hybridd)


    plt.ticklabel_format(style='sci', axis='x', scilimits=(0, 0))
    #BT=[x/ 1000 for x in BT]
    #print('BT',BT)
    #BTx=[0.0, 64.67370900000002, 129.347418, 194.021127, 258.694836, 323.3685449999999]
    #CF=[x/ 1000 for x in CF]
    #CFx=[0.0, 33.298627, 66.59725400000002, 99.89588100000002, 133.194508, 166.493135]
    #print('CF',CF)
    #Integ=[x/ 1000 for x in Integ]
    #print('Integ',Integ)
    #Integx=[0.0, 185.37451700000003, 370.749034, 556.123551, 741.498068, 926.872585]


    #Cube=[x / 1000 for x in Cube]
    #print('Cube',Cube)
    #Cubex=[0.0, 49.262696, 98.525392, 147.788088, 197.050784, 246.31347999999997]


    #Hybrid=[x / 1000 for x in Hybrid]
    #print(Hybrid)
    #Hybridx=Hybrid=[0.0, 0.6545263333333334, 1.3090526666666666, 1.9635789999999997, 2.618105333333333, 3.2726316666666664]



    print('integ', Integ)
    print('Hybrid', Hybrid)
    '''BT=[0,16717.322, 153676.914, 416192.541,610377.154, 717586.101, 974338.943]
    Integ=[0, 185982.6, 887733.164, 2221293.59, 3078144.771, 3678144.771,4659955.536]
    CF=[0,9062.794
,66142.171
,176546.565
,193723.66
,330085.767
,475999.678]
    Cube=[0,
49683.104,
457132.223,
1161251.58,
1999237.923,
1854197.439,
2307851.116]
    Hybrid=[0,3927.1580000000004,
52775.4,
125902.228,
246300.319,
367734.326,
365588.452]'''


    #input = [0, 1300318, 2645829, 3917725, 5275056, 6766833,8201640]
    #Integ = [0, 332610.4843, 887733.164,1291293.59, 2221293.59, 2221293.59, 3078144.771]
    ##BT =     [0, 49122.635, 165404.065, 271869.023, 407503.58999999997, 561587.647,4659955.536]
    #CF =     [0, 112064.45899999999, 320137.929, 501814.231, 808946.446, 4104354.091,0]
    #Cube =   [0, 304128.885/2, 457132.912/2, 1153063.723/2, 2018331.804/2, 4655296.498000001/2,0]
    #Hybrid = [0, 12478.974, 38423.032, 57001.325000000004, 105860.179, 144900.207,0]


    input = [0,640966,
2645829,
6016009,
8201640,
9233927,
10130401]

    SnowB=[0,
1913.433,
11500.305,
29245.329,
40326.933,
45807.926,
50749.694]
    Snow=[0,30107.165,
80089.021,
196005.652,
300334.207,
350000,
395085.991]
    print('BT',BT)



    print('CF', CF)
    #plt.plot(input, Snow , marker='o', linestyle='-', color='g', label='Snow (Integrated)')
    #plt.plot(input, Integ , marker='o', linestyle='-', color='g', label='Integrated')

    visiB=[0,3554.644,
31894.775,
92004.312,
139577.312,
165138.497,
188335.185]
    Visi=[0,31852.696,
115118.442,
290103.247,
396273.229,
450000,
500061.565]
    print('Cube', Cube)
    plt.plot(input, [x/1000 for x in Visi], marker='o', linestyle='-', color='r', label='LowVisibility (Integrated Table)')


    wind = [0,41852.696,
155118.442,
350103.247,
486273.229,
550000,
612261.565]


    WindB=[0,
6411.179,
51605.228,
153095.924,
215590.981,
247952.031,
276871.371]
    plt.plot(input,  [x/1000 for x in wind] , marker='o', linestyle='-', color='b', label='WindSpeed (Integrated Table)')



    Thunder=[0,
2253.013,
24794.911,
59940.124,
90686.624,
96105.477,
130618.213]


    plt.xlim([0, 10130401])
    plt.plot(input, [x/1000 for x in visiB], marker='o', linestyle='--', color='r', label='LowVisibility (Base Tables)')


    plt.plot(input, [x/1000 for x in WindB], marker='o', linestyle=':', color='b', label='WindSpeed (Base Tables)')

    #plt.plot(input, SnowB, marker='o', linestyle=':', color='g',
     #    label='Snow (Base)')  #plt.plot(input, Thunder, marker='o', linestyle='-.', color='g', label='Hybrid')
    #print('Hybrid', Hybrid)

    #plt.plot(input, Hybrid, marker='o', linestyle='-.', color='r', label='Hybrid')
    #plt.plot(input, [x/ 6000 for x in  factoring_cost], marker='o', linestyle=':', color='b', label='Factorization Cost')


    #plt.plot(input, [x/ 6000 for x in   Cube_cost], marker='o', linestyle=':', color='r', label='Factorization Cost')  #axes = plt.gca()
    #axes.set_xlim([1, 100])
    #axes.set_ylim([25, 250])
    plt.xlabel('Input Rows')
    plt.ylabel('Time in Second')
    #plt.title('Pushing Matching')
    plt.legend(loc='upper left')
    plt.savefig('/Users/babakmac/Google Drive/opt1.png')
    plt.show()


def readresutlts():
    mypath='/Users/babakmac/Google Drive/01.My Papers/VLDB2016/VLDB2016/vldb-causality-paper/Code/SQL/scripts/Scalibility/NewScripts/'
    #mypath='C:\\Users\\bsalimi\\Google Drive\\01.My Papers\\VLDB2016\\VLDB2016\\vldb-causality-paper\\Code\\SQL\\scripts\\new\\NewScripts\\'
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    print({'2014.out','2011.out'})
    for file in onlyfiles:
        querynum=0
        tempdic=list();
        extention=file.split('.')[1]
        tag=0

        if extention=='out':
            #print(file)
            querynum = 0
            counter = 0;
            tag=0
            with open(mypath+file) as infile:
                for line in infile:
                    if line.__contains__('q'):

                       if tag==1:
                           querynum=querynum+1
                           counter=0;
                           tag=1
                           if querynum==6:
                               dic['Base Relation']=copy.deepcopy(tempdic)
                               tempdic.clear()
                           if querynum==10:
                             dic['Integrated']= copy.deepcopy(tempdic)
                             tempdic.clear()
                           if querynum == 17:
                             dic['Covariate Factoring'] = copy.deepcopy(tempdic)
                             tempdic.clear()
                             tempdic.clear()
                           if querynum == 23:
                               dic['Data Cube'] = copy.deepcopy(tempdic)
                               tempdic.clear()
                           if querynum == 30:
                               dic['Hybrid1'] = copy.deepcopy(tempdic)
                               tempdic.clear()
                       else: tag=1
                    if line.__contains__('Time:'):
                                if counter==1:
                                    tmp=dict()
                                    tmp[querynum]=line.split(' ')[1]

                                    if querynum == 38:
                                        tempdic.append(tmp)
                                        dic['Hybrid2'] = copy.deepcopy(tempdic)
                                    tempdic.append(tmp)
                                    if querynum > 0:
                                     counter = counter + 1
                                else:
                                    if querynum>0:
                                     counter =counter+1;
                parentdic[file.split('.')[0]] = copy.deepcopy(dic)

    return parentdic


lables = {'Base Relation': {}, 'Covariate Factoring': {}, 'Covariate Factoring': {}, 'Data Cube': {}, 'Hybrid1': {},
          'Hybrid2': {}}

if __name__ == "__main__":
    runexp4()
    #r=json.dumps(dic)
    ##print('Base Relation',dic['2014']['Base Relation'])
    #print('Covariate Factoring',dic['2014']['Covariate Factoring'])
    #print('Data Cube',dic['2014']['Data Cube'])
    #print('Hybrid1',dic['2014']['Hybrid1'])
    #print('Hybrid2',dic['2014']['Hybrid2'])

    #with  open("/Users/babakmac/Google Drive/01.My Papers/VLDB2016/VLDB2016/vldb-causality-paper/Code/SQL/scripts/new/NewScripts/scale.json", "w") as outfile:
    #  json.dump(r,outfile)
    #runexp3()
    #runexp()
    runexp4()
    #readresutlts()
    #runexp2()
    #runexp3()
    #runexp3()