# coding: utf-8
from collections import Counter

with open('gpl-3.0.txt','r') as f:
    file = f.readlines()
    
filestripped = file.translate(None,string.punctuation).replace('\n',' ').lower()
c = Counter()
c.update(filestripped.split())
len(c)
print c # note this prints it in an ordered form
