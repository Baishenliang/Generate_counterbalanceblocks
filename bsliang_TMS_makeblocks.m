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

% ԭ�򣺣�1��Sham��Զ���м䣻
%       ��2�����������̼���
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
    
BLOCKS={{'����'},{1,2},par_num/2;
    {'����'},par_cell,5;...
    {'������е�'},LSTS',4;...
    {'PTCN'},PTCN',1};
% �ò����������֣��ò�������blocks��ÿ��block������һ��Ķ��ٸ�blocks������level������Ϊblock��������һ��Ҳ���ǲ�һ����block��
% �ڶ����ر�ע�⣬ָ���ǲ�ͬ������ѭ��˳����һ�����ڣ�������ڱ���ƽ�⣩Ϊ׼��д��

% par_code�Ǳ��Ե����࣬���ǵı���ͬ�ʣ�����о������豻��ͬ�ʣ����������౻�ԣ���ô����1:2����
% par_code֮���Ǳ��Լ�������par_code֮���Ǳ�����������
% levels��matrix��cell��ʾ�����ԣ�ά�Ȳ��ޣ����ǳ�������ʱ���ӵ�ά�ȿ�ʼ�֣���ע��ά��˳��

[output,output_index]=baliang_makeblocks_20190921(BLOCKS,2);

save blockmatrix output