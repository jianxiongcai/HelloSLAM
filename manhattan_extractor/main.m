%%%
% Manhattan Frame Extraction
% Main Script
%%%

clear;
clc;

Rraw = csvread('../data/180101T174705X180101T174736data.csv');
Rraw = Rraw(:,5:7);

dList = dir('../data/180101T174705video-merge/*.mat');

K = [3445.70873,          0, 2043.54468;
              0, 3460.33339, 1402.65900;
              0,          0,          1];

tic;
% Vote on the gaussian sphere.
[g_sph,votes] = vote(K,dList,Rraw);
% Mark up the corresponding manhattan directions of the lines.
[M,lns] = extractManhattan(g_sph,votes,dList,Rraw,K);
toc;