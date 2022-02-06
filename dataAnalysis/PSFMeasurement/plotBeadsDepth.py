# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd

import seaborn as sns

import matplotlib.pyplot as plt

da=pd.read_csv(r'C:\Users\BBNC\Downloads\findNeuron\Dtable.csv')
da.rename(columns={'0':'FOV','0.1':'thickness','0.2':'z'},inplace=True)
#da.rename(columns={'0':'FOV','1.2251':'h'},inplace=True)
#da.drop('FOV',1,inplace=True)
#da.drop('1.1',1,inplace=True)
#sns.boxplot(x="FOV",y="h",data=da, palette="Set3")
#plt.show()
#print(da.groupby(["FOV"])["h"].describe())
#sns.lmplot(x="thickness", y="z", hue="FOV", data=da);


p=pd.read_csv(r'C:\Users\BBNC\Downloads\findNeuron\p.csv')
ax=sns.distplot(p)
plt.savefig('./filename.svg',format='svg')
