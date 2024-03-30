function [output,output_index]=baliang_makeblocks_20190921(BLOCKS,par_level)
    BLOCKS_check_mat=ones(size(BLOCKS,1),2);
    
    %第一步：检查是否符合最小公倍数原则（也就是设定的blocks组合可以循环完）
    %解释原理比较复杂，看视频教程《makeblocks是怎么检查的》。
    
    for row=1:size(BLOCKS,1)
        BLOCKS_check_mat(row,1)=length(reshape(BLOCKS{row,2},1,[]));
        BLOCKS_check_mat(row,2)=BLOCKS{row,3};
    end
    %check step1
    for row=size(BLOCKS_check_mat,1):-1:2
        for row_p=1:row-1
            BLOCKS_check_mat(row,2)=BLOCKS_check_mat(row,2)*BLOCKS_check_mat(row_p,2);
        end
    end
    %check step2
    mods=0;
    for row=2:size(BLOCKS_check_mat,1)
        mods=mods+mod(BLOCKS_check_mat(row-1,2)*BLOCKS_check_mat(1,1),BLOCKS_check_mat(row,1));
    end
    if mods==0
        msgbox('通过最小公倍数检验，在实验给出的循环中可以正整数地循环完所有设定的blocks序列。');
    else
        msgbox('没有通过最小公倍数检验，在实验给出的循环中不可以正整数地循环完所有设定的blocks序列。');
    end
    
    %下面是生成要输出的刺激，从上到下是从高层到低层
    BLOCKS_unit_lst=ones(size(BLOCKS,1),1); %一个block有多少个unit（最底层level的一个单位）
    for row=1:size(BLOCKS,1)
        BLOCKS_unit_lst(row,1)=BLOCKS{row,3};
    end
    for row=1:size(BLOCKS_unit_lst,1)-1
        for row_p=row+1:size(BLOCKS_unit_lst,1)
            BLOCKS_unit_lst(row,1)=BLOCKS_unit_lst(row,1)*BLOCKS_unit_lst(row_p,1);
        end
    end
    BLOCKS_unit_lst=BLOCKS_unit_lst';
    output=cell(size(BLOCKS,1),BLOCKS_check_mat(end-1,2)*BLOCKS_check_mat(1,1));
    output_index=output;
    block_pointer=ones(1,size(output,1));
    for trial=1:size(output,2)
        for level=1:size(output,1)
            block_pointer(1,level)= bsliang_accumulator(trial,BLOCKS_unit_lst(1,level),1,BLOCKS_check_mat(level,1));
        end
        for lev=1:size(output,1)
            output{lev,trial}=BLOCKS{lev,2}{block_pointer(1,lev)};
            output_index{lev,trial}=block_pointer(1,lev);
        end
    end
    pars=cell2mat(BLOCKS{par_level,2});
    output_parblock=cell(pars(end)*size(output,1),size(output,2)/pars(end)+1);
    for par=pars
        for item=1:size(output,1)
            output_parblock((par-1)*size(output,1)+item,1)=BLOCKS{item,1};
        end
        output_parblock((par-1)*size(output,1)+1:par*size(output,1),2:end)=output(:,(par-1)*end/pars(end)+1:par*end/pars(end));
    end
    disp('正在写入xlsx文件……')
    xlswrite('output_parblock.xlsx',output_parblock);
    disp('写入完毕。')
    
    %下面检查witin levels (就是par_level下面的levels) counterbalance操作的合理性
    %原则：对于每一个level，它的子levels的每一种block的位置都要一样，而且不同的levels相互独立
    %【这是一个不成熟的方案，需要综合考虑各个方面来做决策】
    %最高原则：（1）对于组内设计的每一个自变量，要求不同水平的平均位置保持一致【】（如：ABBA BAAB设计，counterbalance...抵消练习效应和自变量不同水平的效应的混淆）
    %         （2）对于自变量的每一个水平，要求所有无关变量的不同水平的平均位置保持一致（其实我没发现什么理论基础，但是无关变量的顺序如果与自变量有交互作用就很麻烦，所以还是平衡一下吧）
    
    %【【【【【下面这一大堆废话都是在说明一个原则：所有的变量构成的多位空间里，每个子空间（所有变量的某一水平组成的数集）的值（平均位置）保持一致即可】】】】】】】】】】】】】】】】】】】】】】】】】】】】】】】
    
    %=================废话，可看可不看===============================================================================
    %举TMS研究为例子：
    
    %我们需要对比以下的自变量各水平：
    %（1）被试间：左侧 vs 右侧，那么无关变量有：刺激靶点、DiId、PTCN
    %（2）被试内：刺激靶点（L vs S vs T），那么需要确保LST对于所有被试平均位置一致，无关变量有：DiId、PTCN
    %（3）被试内：P vs T(有噪声或无噪声)，那么需要确保PT(有噪声或无噪声)对于所有被试平均位置一致
    
    % 也就是：我们需要在Noise和clear两个水平上，半球、靶点、DiId、PT四个变量相互正交
    
    %预期，刺激右侧喉部区影响声调判断不影响音位判断，刺激左侧舌部影响音位判断不影响声调判断
    %统计：(Tone|半球=右侧,靶点=L）> (Phon|半球=右侧,靶点=L），(Phon|半球=左侧,靶点=T）> (Tone|半球=左侧,靶点=T）分别对于N C和Di Id有效应
    %所以我们分开N C和Di Id，需要看到在四种条件中： 对于半球*靶点的6种情况，P和T的位置都保持不变（抵消练习效应）
    
    %==================================================================================================================
    
    %方法：列联表
    outw=output;
    for i=1:size(outw,1)
        %将刺激矩阵的数字转化为字符串，以免报错
        for j=1:size(outw,2)
            if isnumeric(outw{i,j})
                outw{i,j}=num2str(outw{i,j});
                if length(outw{i,j})<length(num2str(outw{i,end}))
                    outw{i,j}=[repmat('0',1,length(num2str(outw{i,end}))-length(outw{i,j})),outw{i,j}];%补全数位
                end
            end
        end
    end
    %这个检测的意思是，对于刺激的每一行，刺激这一行的所有类型作为列，其下某一行的所有类型作为行，输出其下某一行的每个类型在刺激这一行的某一类型的所有情况的平均位置。
    %比如：
    %          A      B
    %      C   2      2
    %      D   2      2
    %那么C D在A B这一行里就平衡好了。
    for outw_lev_col=1:size(outw,1)
        %对于矩阵的每一行，都进行计算
        outw_col=outw(outw_lev_col,:);% 这次计算的母行
        outw_cu=unique(outw_col);% 母行的所有类型
        for outw_lev_row=1:size(outw,1); % 对于这一母行之外的每一子行
            if outw_lev_row~=outw_lev_col
                outw_row=outw(outw_lev_row,:); %选取一个子行 
                outw_ru=unique(outw_row); %子行的所有类型
                outw_mat=cell(length(outw_ru)+1,length(outw_cu)+1); %输出的表
                outw_mat{1,1}='均位';
                for cu=1:length(outw_cu) % 对于母行的每一种类型
                    Tag_c=outw_cu{cu}; % 母行这一类型的Tag
                    outw_mat{1,cu+1}=Tag_c; % 给表格赋予母行的类型Tag
                    for ru=1:length(outw_ru) %对于子行的每一种类型
                        Tag_r=outw_ru{ru};
                        outw_mat{ru+1,1}=Tag_r;
                        log=zeros(1,length(outw_col)); %这个log用来选取母行中属于Tag类型的元素
                        for crt=1:length(log)
                            if isequal(outw_col{crt},Tag_c)
                                log(crt)=1;
                            end
                        end
                        outw_row_r=outw_row(logical(log)); %选取对应母行属于Tag母行类型的子行的部分
                        log_r=zeros(1,length(outw_row_r)); % 这个log_r用来选取子行中属于Tag类型的元素
                        for crt=1:length(log_r)
                            if isequal(outw_row_r{crt},Tag_r)
                                log_r(crt)=1;
                            end
                        end                    
                        outw_mat{ru+1,cu+1}=mean(find(log_r)); %计算母行等于Tag_c的所有情况下子行等于Tag_r的平均位置
                    end
                end
                disp('==================================================================================================')
                disp(['计算[',BLOCKS{outw_lev_col,1}{1},']的每一类型里[',BLOCKS{outw_lev_row,1}{1},']的每一种类型的平均位置：'])
                disp(outw_mat);
            end
        end
    end
    
    
    
function output=bsliang_accumulator(input,acc,outmin,outmax) 
    %input是线性增长的正整数，output是周期脉冲，线性增长到一定值后返回初始值
    %当input累加了acc后output加1
    
    output=floor((input-1)/acc)+outmin;
    output=bsliang_mod(output,outmax);
    
        %下面代码为测试代码：
%     for i=1:50
%         disp([num2str(i),' ',num2str(bsliang_accumulator(i,3,1,5))]);
%     end
%   这个代码输出的就是：1 1 1 2 2 2 3 3 3 4 4 4 5 5 5 1 1 1 2 2 2 3 3 3...