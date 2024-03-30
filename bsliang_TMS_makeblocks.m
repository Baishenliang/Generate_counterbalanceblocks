clear all
clc
par_num=48;
par_cell=cell(1,par_num);
for par=1:par_num
    par_cell{1,par}=par;
end


PTCN = {'A'	'B'	'C'	'D',	'B'	'C'	'D'	'A',    	'A' 'B' 'C' 'D',    	'C'	'D'	'A'	'B',	'D'	'A'	'B'	'C';
        'B'	'C'	'D'	'A',	'C'	'D'	'A'	'B',    	'B' 'C' 'D' 'A',    	'D'	'A'	'B'	'C',    'A'	'B'	'C'	'D';
        'C'	'D'	'A'	'B',	'D'	'A'	'B'	'C',    	'C' 'D' 'A' 'B',    	'A'	'B'	'C'	'D',    'B'	'C'	'D'	'A';
        'D'	'A'	'B'	'C',    'A'	'B'	'C'	'D',     	'D' 'A' 'B' 'C',    	'B'	'C'	'D'	'A',    'C'	'D'	'A'	'B'};
PTCN = [PTCN;flip(PTCN)];

% 原则：（1）Sham永远在中间；
%       （2）左右脑相间刺激；
LSTS = {'LI' 'RC' 'Sham' 'LC' 'RI'; % iSham
        'RC' 'LC' 'Sham' 'RI' 'LI'; % iSham
        'LC' 'RI' 'Sham' 'LI' 'RC'; % cSham
        'RI' 'LI' 'Sham' 'RC' 'LC'; % cSham
        'LI' 'RC' 'Sham' 'LC' 'RI'; % cSham
        'RC' 'LC' 'Sham' 'RI' 'LI'; % cSham
        'LC' 'RI' 'Sham' 'LI' 'RC'; % iSham
        'RI' 'LI' 'Sham' 'RC' 'LC'}; % iSham
    
counterShams=repmat({'iSham','iSham','cSham','cSham','cSham','cSham','iSham','iSham'},1,6);
save counterShams counterShams
    
% % LSTS = {'LI' 'RC' 'Sham' 'LC' 'RI';
% %         'LI' 'RC' 'Sham' 'RI' 'LC';
% %         'RC' 'LI' 'Sham' 'LC' 'RI';
% %         'RC' 'LI' 'Sham' 'RI' 'LC';
% %         'LC' 'RI' 'Sham' 'LI' 'RC';
% %         'RI' 'LC' 'Sham' 'LI' 'RC';
% %         'LC' 'RI' 'Sham' 'RC' 'LI';
% %         'RI' 'LC' 'Sham' 'RC' 'LI' };
% %     
%  LSTS = [LSTS;LSTS];
    
% IdDi = {'Id' 'Di',  'Di' 'Id',	'Id' 'Di',  'Di' 'Id';
%         'Di' 'Id',	'Id' 'Di',  'Di' 'Id',  'Id' 'Di'};
% IdDi = [IdDi;flip(IdDi)];
    
BLOCKS={{'脑区'},{1,2},par_num/2;
    {'被试'},par_cell,5;...
    {'半球×靶点'},LSTS',4;...
    {'PTCN'},PTCN',1};
% 该层条件的名字，该层条件的blocks，每个block包含下一层的多少个blocks（不是level哈，因为block即便条件一样也算是不一样的block）
% 第二列特别注意，指的是不同条件的循环顺序，以一个周期（这个周期必须平衡）为准填写。

% par_code是被试的种类，我们的被试同质（如果研究不假设被试同质，比如有两类被试，那么就是1:2）；
% par_code之上是被试间条件，par_code之下是被试内条件；
% levels用matrix或cell表示都可以，维度不限，但是程序计算的时候会从低维度开始轮，请注意维度顺序

[output,output_index]=baliang_makeblocks_20190921(BLOCKS,2);

save blockmatrix output