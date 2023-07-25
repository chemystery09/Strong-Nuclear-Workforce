#import pandas as pd
import csv
import os

script_dir = os.path.dirname(__file__) #<-- absolute dir the script is in
abs_file_path = os.path.join(script_dir, "penguins.csv")

penguins=open(abs_file_path)

lines=penguins.readlines()
lines.pop(0)
print(lines[0])
new_peng=[]
for i in range(len(lines)):
    w=lines[i].split(",")
    #print(w)
    k=True
    l=False
    for j in w:
        if "Gentoo" in j:
            k=False
        if "female" in j:
            l=True
    if k and l:
        print(w)
        new_peng.append(w)

# 1 is Chinstrap
# 2 is Adelie
check=[]
val=[]
for i in range(len(new_peng)):
    if "Adelie" in new_peng[i][1]:
        check.append(2)
    else:
        check.append(1)
    val.append([new_peng[i][3],new_peng[i][4],new_peng[i][5],new_peng[i][6]])
print(val)
print(check)


with open('check', 'w') as f:
    # using csv.writer method from CSV package
    write = csv.writer(f)
    write.writerow(check)

with open('1val', 'w') as f:
    # using csv.writer method from CSV package
    write = csv.writer(f)
    write.writerows(val)
    