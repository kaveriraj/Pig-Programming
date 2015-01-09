--Project2
--Harshil Desai SID: 13593841
--Kaveri Krishnaraj SID: 13053051 
— Frequent Itemset Mining in Pig Latin
S = LOAD '$input' USING PigStorage() as (tid: chararray, item: int);
A = GROUP S BY item;
B = FOREACH A GENERATE group as item, COUNT(S) as freq;
C = FILTER B BY freq >= $support;
C1 = FOREACH C GENERATE *;
D = CROSS C, C1;
E = FILTER D BY C::item < C1::item;
F = FOREACH E GENERATE C::item as item1, C1::item as item2;
S1 = FOREACH S GENERATE *;
S2 = FOREACH S GENERATE *;
G = JOIN F BY item1,S1 BY item;
H = JOIN G BY item2,S2 BY item;
I = FILTER H BY (S1::tid == S2::tid);
J = GROUP I BY (F::item1, F::item2);
K = FOREACH J GENERATE group, COUNT(I) as Frequency;
X = FILTER K BY Frequency >= $support;

M = FOREACH F GENERATE *;
M1 = FOREACH F GENERATE *;
N = CROSS M, M1;
O = FILTER N BY (M::item1 == M1::item1) AND (M::item2 < M1::item2);
P = FOREACH O GENERATE M::item1 as item1, M::item2 as item2, M1::item2 as item3;
S3 = FOREACH S GENERATE *;
Q = JOIN P BY item1,S1 BY item;
R = JOIN Q BY item2,S2 BY item;
T = JOIN R BY item3,S3 BY item;
U = FILTER T BY (S1::tid == S2::tid) AND (S2::tid == S3::tid);
V = GROUP U BY (P::item1, P::item2, P::item3);
W = FOREACH V GENERATE group, COUNT(U) as Frequency;
Y = FILTER W BY Frequency >= $support;

STORE X INTO '$output/X';
STORE Y INTO '$output/Y';
