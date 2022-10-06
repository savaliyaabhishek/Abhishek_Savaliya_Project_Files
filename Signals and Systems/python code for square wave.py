# -*- coding: utf-8 -*-
"""
Created on Fri Sep  9 21:56:48 2022

@author: ABISHEK SAVALIYA
"""

import matplotlib.pyplot as plt;
import numpy as np

n=15
sum=0
f=20
t = np.linspace(-20,20,100)
for i in range (1,1000,2):
    sum += (4*(np.sin(np.pi*i*f*t)))/(i*np.pi)

plt.plot(t,sum, 'orange')   
plt.show();  