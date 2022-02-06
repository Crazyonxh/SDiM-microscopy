# -*- coding: utf-8 -*-
"""
Created on Tue Jan 25 11:55:16 2022

@author: BBNC
"""

"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd

import seaborn as sns

import matplotlib.pyplot as plt

da=pd.read_csv(r'C:\Users\BBNC\Downloads\findNeuron\Ntable2.csv')
da.rename(columns={'0':'distance','0.030202':'correlation'},inplace=True)
#da.rename(columns={'0':'FOV','1.2251':'h'},inplace=True)
#da.drop('FOV',1,inplace=True)
#da.drop('1.1',1,inplace=True)
ax=sns.boxplot(x="distance",y="correlation",data=da, palette="Set3")
ax.set_ylim(0,0.15)

plt.show()
#print(da.groupby(["FOV"])["h"].describe())
#sns.lmplot(x="thickness", y="z", hue="FOV", data=da);


# p=pd.read_csv(r'C:\Users\BBNC\Downloads\findNeuron\p.csv')
# ax=sns.distplot(p)
plt.savefig('./distcorre2.svg',format='svg')
