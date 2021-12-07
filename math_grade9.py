#!/usr/bin/env python
# coding: utf-8

# In[1]:


# Add Matplotlib inline magic command
get_ipython().run_line_magic('matplotlib', 'inline')
# Dependencies and Setup
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# File to Load (Remember to change these)
data = "combine.csv"


# Read Data
math_df = pd.read_csv(data)
math_df.describe()


# In[2]:


classof = 2024


# In[3]:


c310 = math_df[(math_df['course_num'] == 310) & (math_df['class_of'] == classof)]
c320 = math_df[(math_df['course_num'] == 320) & (math_df['class_of'] == classof)]
c321 = math_df[(math_df['course_num'] == 321) & (math_df['class_of'] == classof)]
c331 = math_df[(math_df['course_num'] == 331) & (math_df['class_of'] == classof)]
c337 = math_df[(math_df['course_num'] == 337) & (math_df['class_of'] == classof)]


# In[4]:


c310x = c310['avg_hspt_score']
c320x = c320['avg_hspt_score']
c321x = c321['avg_hspt_score']
c331x = c331['avg_hspt_score']
c337x = c337['avg_hspt_score']
c310y = c310['score']
c320y = c320['score']
c321y = c321['score']
c331y = c331['score']
c337y = c337['score']
a310 = c310x.mean()
a320 = c320x.mean()
a321 = c321x.mean()
a331 = c331x.mean()
a337 = c337x.mean()
p310 = c310y.mean()
p320 = c320y.mean()
p321 = c321y.mean()
p331 = c331y.mean()
p337 = c337y.mean()
yvals = np.arange(0, 120, 1)
b310 = []
b320 = []
b321 = []
b331 = []
b337 = []
for x in range(len(yvals)):
    b310.append(a310)
    b320.append(a320)
    b321.append(a321)
    b331.append(a331)
    b337.append(a337)
q310 = []
q320 = []
q321 = []
q331 = []
q337 = []
for x in range(len(yvals)):
    q310.append(p310)
    q320.append(p320)
    q321.append(p321)
    q331.append(p331)
    q337.append(p337)


# In[5]:


plt.figure(figsize = (20, 20))
plt.scatter(c310x, c310y, c = 'blue', alpha = 0.8, edgecolor="black", label = 'Algebra 1')
plt.scatter(c320x, c320y, c = 'red', alpha = 0.8, edgecolor="black", label = 'Geometry')
plt.scatter(c321x, c321y, c = 'green', alpha = 0.8, edgecolor="black", label = 'Geometry H')
plt.scatter(c331x, c331y, c = 'orange', alpha = 0.8, edgecolor="black", label = 'Algebra 2 H')
plt.scatter(c337x, c337y, c = 'yellow', alpha = 0.8, edgecolor="black", label = 'Pre-Calc H')
plt.plot(b310, yvals, c = 'blue')
plt.plot(b320, yvals, c = 'red')
plt.plot(b321, yvals, c = 'green')
plt.plot(b331, yvals, c = 'orange')
plt.plot(b337, yvals, c = 'yellow')
plt.plot(yvals, q310, c = 'blue')
plt.plot(yvals, q320, c = 'red')
plt.plot(yvals, q321, c = 'green')
plt.plot(yvals, q331, c = 'orange')
plt.plot(yvals, q337, c = 'yellow')
plt.title('Percent in class vs average score on HSPT', fontsize = 30)
plt.xlabel("Score on HSPT", fontsize = 20)
plt.ylabel("Percent in Class", fontsize = 20)
plt.grid(True)
plt.legend()
plt.ylim([65, 101])
plt.xlim([30, 110])
plt.text(31, 68, f'HSPT Averages:')
plt.text(31, 67.5, f'A1 Avg: {a310:.2f}')
plt.text(31, 67, f'Geo Avg: {a320:.2f}')
plt.text(31, 66.5, f'Geo H Avg: {a321:.2f}')
plt.text(31, 66, f'A2 H Avg: {a331:.2f}')
plt.text(31, 65.5, f'PCH Avg: {a337:.2f}')
plt.text(31, 85.5, f'Grade Averages:')
plt.text(31, 85, f'A1 Avg: {p310:.2f}')
plt.text(31, 84.5, f'Geo Avg: {p320:.2f}')
plt.text(31, 84, f'Geo H Avg: {p321:.2f}')
plt.text(31, 83.5, f'A2 H Avg: {p331:.2f}')
plt.text(31, 83, f'PCH Avg: {p337:.2f}')
lgnd = plt.legend(fontsize = '15', mode = 'Expanded', scatterpoints = 1, loc = 'best', title = 'course', title_fontsize = '20')
#plt.savefig('Percent_in_class_vs_score_HSPT_RDNP.png')


# In[6]:


my_list = []
my_list2 = []
my_dict= {}
for classof in range(2021, 2025, 1):
    c310 = math_df[(math_df['course_num'] == 310) & (math_df['class_of'] == classof)]
    c320 = math_df[(math_df['course_num'] == 320) & (math_df['class_of'] == classof)]
    c321 = math_df[(math_df['course_num'] == 321) & (math_df['class_of'] == classof)]
    c331 = math_df[(math_df['course_num'] == 331) & (math_df['class_of'] == classof)]
    c337 = math_df[(math_df['course_num'] == 337) & (math_df['class_of'] == classof)]
    my_list.append(classof)
    my_list2.append(classof)
    c310x = c310['avg_hspt_score']
    c320x = c320['avg_hspt_score']
    c321x = c321['avg_hspt_score']
    c331x = c331['avg_hspt_score']
    c337x = c337['avg_hspt_score']
    c310y = c310['score']
    c320y = c320['score']
    c321y = c321['score']
    c331y = c331['score']
    c337y = c337['score']
    a310 = c310x.mean()
    my_list.append(a310)
    a320 = c320x.mean()
    my_list.append(a320)
    a321 = c321x.mean()
    my_list.append(a321)
    a331 = c331x.mean()
    my_list.append(a331)
    a337 = c337x.mean()
    my_list.append(a337)
    p310 = c310y.mean()
    my_list2.append(p310)
    p320 = c320y.mean()
    my_list2.append(p320)
    p321 = c321y.mean()
    my_list2.append(p321)
    p331 = c331y.mean()
    my_list2.append(p331)
    p337 = c337y.mean()
    my_list2.append(p337)
    


# In[7]:


my_list


# In[8]:


my_list2


# In[9]:


ave_hspt = []
my_dict = {}
keys = [2021310, 2021320, 2021321, 2021331, 2021337, 2022310, 2022320, 2022321, 2022331, 2022337, 2023310, 2023320, 2023321, 2023331, 2023337, 2024310, 2024320, 2024321, 2024331, 2024337]
for classof in range(2021, 2025, 1):
    c310 = math_df[(math_df['course_num'] == 310) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    c320 = math_df[(math_df['course_num'] == 320) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    c321 = math_df[(math_df['course_num'] == 321) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    c331 = math_df[(math_df['course_num'] == 331) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    c337 = math_df[(math_df['course_num'] == 337) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    print(f'{c310}, {c320}, {c321}, {c331}, {c337}\n')
    ave_hspt.append(c310)
    ave_hspt.append(c320)
    ave_hspt.append(c321)
    ave_hspt.append(c331)
    ave_hspt.append(c337)
for i in range(20):
    my_dict[keys[i]] = ave_hspt[i]
    


# In[10]:


my_dict[2021310]


# In[14]:


years = [2021, 2022, 2023, 2024]
courses = [310, 320, 321, 331, 337]
combine = {}
ave = []
for classof in range(2021, 2025, 1):
    c310 = math_df[(math_df['course_num'] == 310) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    c320 = math_df[(math_df['course_num'] == 320) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    c321 = math_df[(math_df['course_num'] == 321) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    c331 = math_df[(math_df['course_num'] == 331) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    c337 = math_df[(math_df['course_num'] == 337) & (math_df['class_of'] == classof)]['avg_hspt_score'].mean()
    print(f'{c310}, {c320}, {c321}, {c331}, {c337}\n')
    ave_hspt.append(c310)
    ave_hspt.append(c320)
    ave_hspt.append(c321)
    ave_hspt.append(c331)
    ave_hspt.append(c337)
    


# In[12]:


c310


# In[ ]:




