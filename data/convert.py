import pandas as pd
import csv


penguins=open(r'C:\Users\ceqcx\Downloads\data\penguins.csv')

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
        check.append(1)
    else:
        check.append(0)
    val.append([new_peng[i][3],new_peng[i][4],new_peng[i][5],new_peng[i][6]])
print(val)
print(check)
sum1=0
sum2=0
sum3=0
sum4=0
for i in range(len(val)):
    sum1+=float(val[i][0])
    sum2+=float(val[i][1])
    sum3+=float(val[i][2])
    sum4+=float(val[i][3])
for i in range(len(val)):
    val[i][0]=float(val[i][0])/sum1
    val[i][1]=float(val[i][1])/sum2
    val[i][2]=float(val[i][2])/sum3
    val[i][3]=float(val[i][3])/sum4
val_test=val[:int(20/100*len(val))]
val_train=val[int(20/100*len(val)):]
check_test=check[:int(20/100*len(val))]
check_train=check[int(20/100*len(val)):]

with open('0check_test', 'w') as f:
    # using csv.writer method from CSV package
    write = csv.writer(f)
    write.writerow(check_train)

with open('0val_test', 'w') as f:
    # using csv.writer method from CSV package
    write = csv.writer(f)
    write.writerows(val_train)
    
with open('0check_train', 'w') as f:
    # using csv.writer method from CSV package
    write = csv.writer(f)
    write.writerow(check_train)

with open('0val_train', 'w') as f:
    # using csv.writer method from CSV package
    write = csv.writer(f)
    write.writerows(val_train)