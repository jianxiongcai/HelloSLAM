%%%
% Manhattan Frame Extraction
% Main Script
%%%
clear;
clc;

Rraw1 = csvread('../data/171229T132838X171229T132945data.csv');
Rraw1 = Rraw1(:,5:7);
Rraw2 = csvread('../data/171229T133050X171229T133136data.csv');
Rraw2 = Rraw2(:,5:7);

dList1 = dir('../data/171229T132838video/*.txt');
dList2 = dir('../data/171229T133050video/*.txt');

K = [3445.70873,          0, 2043.54468;
              0, 3460.33339, 1402.65900;
              0,          0,          1];
          
vp1 = '171229T132838video';
vp2 = '171229T133050video';

[P1,M1] = extractManhattan(K,dList1,Rraw1,vp1);
[P2,M2] = extractManhattan(K,dList2,Rraw2,vp2);