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


%       ��2�����������̼���
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
% �ò����������֣��ò�������blocks��ÿ��block������һ��Ķ��ٸ�blocks������level������Ϊblock��������һ��Ҳ���ǲ�һ����block��
% �ڶ����ر�ע�⣬ָ���ǲ�ͬ������ѭ��˳����һ�����ڣ�������ڱ���ƽ�⣩Ϊ׼��д��

% par_code�Ǳ��Ե����࣬���ǵı���ͬ�ʣ�����о������豻��ͬ�ʣ����������౻�ԣ���ô����1:2����
% par_code֮���Ǳ��Լ�������par_code֮���Ǳ�����������
% levels��matrix��cell��ʾ�����ԣ�ά�Ȳ��ޣ����ǳ�������ʱ���ӵ�ά�ȿ�ʼ�֣���ע��ά��˳��

[output,output_index]=baliang_makeblocks_20190921(BLOCKS,2);

save blockmatrix output