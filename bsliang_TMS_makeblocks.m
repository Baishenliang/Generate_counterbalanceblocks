clear all
clc
par_num=24;
par_cell=cell(1,par_num);
for par=1:par_num
    par_cell{1,par}=par;
end

% 
% PTCN = {'A'	'B'	'C'	'D',	'B'	'C'	'D'	'A',    	'A' 'B' 'C' 'D',    	'C'	'D'	'A'	'B',	'D'	'A'	'B'	'C';
%         'B'	'C'	'D'	'A',	'C'	'D'	'A'	'B',    	'B' 'C' 'D' 'A',    	'D'	'A'	'B'	'C',    'A'	'B'	'C'	'D';
%         'C'	'D'	'A'	'B',	'D'	'A'	'B'	'C',    	'C' 'D' 'A' 'B',    	'A'	'B'	'C'	'D',    'B'	'C'	'D'	'A';
%         'D'	'A'	'B'	'C',    'A'	'B'	'C'	'D',     	'D' 'A' 'B' 'C',    	'B'	'C'	'D'	'A',    'C'	'D'	'A'	'B'};
% PTCN = [PTCN;flip(PTCN)];

 % 1 2 1
 % 2 1 2
 % 1 2 1
 % 2 1 2
 % 1 2 1
 % 2 1 2

PTCN = {'A'	'B'	'C'	'D', 'C' 'D' 'A' 'B', 'A' 'B' 'C' 'D';
              'C' 'D' 'A' 'B', 'A' 'B' 'C' 'D', 'C' 'D' 'A' 'B';
              'A' 'B' 'C' 'D', 'C' 'D' 'A' 'B', 'A' 'B' 'C' 'D';
              'D' 'C' 'B' 'A', 'B' 'A' 'D' 'C', 'D' 'C' 'B' 'A';
              'B' 'A' 'D' 'C', 'D' 'C' 'B' 'A', 'B' 'A' 'D' 'C';
              'D' 'C' 'B' 'A', 'B' 'A' 'D' 'C', 'D' 'C' 'B' 'A'};


%       （2）左右脑相间刺激；
LSTS = {'40Hz tACS' 'Sham' '4Hz tACS';
            'Sham'  '4Hz tACS' '40Hz tACS';
            '4Hz tACS' '40Hz tACS' 'Sham'};
LSTS = [LSTS;flip(LSTS)];
    
counterShams=repmat({'Sham'},1,par_num);
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
    
BLOCKS={{'Hand'},{'Left','Right'},par_num/2;
    {'Subject'},par_cell,3;...
    {'Stimulation'},LSTS',4;...
    {'PTCN'},PTCN',1};
% 该层条件的名字，该层条件的blocks，每个block包含下一层的多少个blocks（不是level哈，因为block即便条件一样也算是不一样的block）
% 第二列特别注意，指的是不同条件的循环顺序，以一个周期（这个周期必须平衡）为准填写。

% par_code是被试的种类，我们的被试同质（如果研究不假设被试同质，比如有两类被试，那么就是1:2）；
% par_code之上是被试间条件，par_code之下是被试内条件；
% levels用matrix或cell表示都可以，维度不限，但是程序计算的时候会从低维度开始轮，请注意维度顺序

[output,output_index]=baliang_makeblocks_20190921(BLOCKS,2);

save blockmatrix output