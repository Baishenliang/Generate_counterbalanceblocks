function [output,output_index]=baliang_makeblocks_20190921(BLOCKS,par_level)
    BLOCKS_check_mat=ones(size(BLOCKS,1),2);
    
    %��һ��������Ƿ������С������ԭ��Ҳ�����趨��blocks��Ͽ���ѭ���꣩
    %����ԭ��Ƚϸ��ӣ�����Ƶ�̡̳�makeblocks����ô���ġ���
    
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
        msgbox('ͨ����С���������飬��ʵ�������ѭ���п�����������ѭ���������趨��blocks���С�');
    else
        msgbox('û��ͨ����С���������飬��ʵ�������ѭ���в�������������ѭ���������趨��blocks���С�');
    end
    
    %����������Ҫ����Ĵ̼������ϵ����ǴӸ߲㵽�Ͳ�
    BLOCKS_unit_lst=ones(size(BLOCKS,1),1); %һ��block�ж��ٸ�unit����ײ�level��һ����λ��
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
    disp('����д��xlsx�ļ�����')
    xlswrite('output_parblock.xlsx',output_parblock);
    disp('д����ϡ�')
    
    %������witin levels (����par_level�����levels) counterbalance�����ĺ�����
    %ԭ�򣺶���ÿһ��level��������levels��ÿһ��block��λ�ö�Ҫһ�������Ҳ�ͬ��levels�໥����
    %������һ��������ķ�������Ҫ�ۺϿ��Ǹ��������������ߡ�
    %���ԭ�򣺣�1������������Ƶ�ÿһ���Ա�����Ҫ��ͬˮƽ��ƽ��λ�ñ���һ�¡������磺ABBA BAAB��ƣ�counterbalance...������ϰЧӦ���Ա�����ͬˮƽ��ЧӦ�Ļ�����
    %         ��2�������Ա�����ÿһ��ˮƽ��Ҫ�������޹ر����Ĳ�ͬˮƽ��ƽ��λ�ñ���һ�£���ʵ��û����ʲô���ۻ����������޹ر�����˳��������Ա����н������þͺ��鷳�����Ի���ƽ��һ�°ɣ�
    
    %����������������һ��ѷϻ�������˵��һ��ԭ�����еı������ɵĶ�λ�ռ��ÿ���ӿռ䣨���б�����ĳһˮƽ��ɵ���������ֵ��ƽ��λ�ã�����һ�¼��ɡ�������������������������������������������������������������
    
    %=================�ϻ����ɿ��ɲ���===============================================================================
    %��TMS�о�Ϊ���ӣ�
    
    %������Ҫ�Ա����µ��Ա�����ˮƽ��
    %��1�����Լ䣺��� vs �Ҳ࣬��ô�޹ر����У��̼��е㡢DiId��PTCN
    %��2�������ڣ��̼��е㣨L vs S vs T������ô��Ҫȷ��LST�������б���ƽ��λ��һ�£��޹ر����У�DiId��PTCN
    %��3�������ڣ�P vs T(��������������)����ô��Ҫȷ��PT(��������������)�������б���ƽ��λ��һ��
    
    % Ҳ���ǣ�������Ҫ��Noise��clear����ˮƽ�ϣ����򡢰е㡢DiId��PT�ĸ������໥����
    
    %Ԥ�ڣ��̼��Ҳ����Ӱ�������жϲ�Ӱ����λ�жϣ��̼�����ಿӰ����λ�жϲ�Ӱ�������ж�
    %ͳ�ƣ�(Tone|����=�Ҳ�,�е�=L��> (Phon|����=�Ҳ�,�е�=L����(Phon|����=���,�е�=T��> (Tone|����=���,�е�=T���ֱ����N C��Di Id��ЧӦ
    %�������Ƿֿ�N C��Di Id����Ҫ���������������У� ���ڰ���*�е��6�������P��T��λ�ö����ֲ��䣨������ϰЧӦ��
    
    %==================================================================================================================
    
    %������������
    outw=output;
    for i=1:size(outw,1)
        %���̼����������ת��Ϊ�ַ��������ⱨ��
        for j=1:size(outw,2)
            if isnumeric(outw{i,j})
                outw{i,j}=num2str(outw{i,j});
                if length(outw{i,j})<length(num2str(outw{i,end}))
                    outw{i,j}=[repmat('0',1,length(num2str(outw{i,end}))-length(outw{i,j})),outw{i,j}];%��ȫ��λ
                end
            end
        end
    end
    %���������˼�ǣ����ڴ̼���ÿһ�У��̼���һ�е�����������Ϊ�У�����ĳһ�е�����������Ϊ�У��������ĳһ�е�ÿ�������ڴ̼���һ�е�ĳһ���͵����������ƽ��λ�á�
    %���磺
    %          A      B
    %      C   2      2
    %      D   2      2
    %��ôC D��A B��һ�����ƽ����ˡ�
    for outw_lev_col=1:size(outw,1)
        %���ھ����ÿһ�У������м���
        outw_col=outw(outw_lev_col,:);% ��μ����ĸ��
        outw_cu=unique(outw_col);% ĸ�е���������
        for outw_lev_row=1:size(outw,1); % ������һĸ��֮���ÿһ����
            if outw_lev_row~=outw_lev_col
                outw_row=outw(outw_lev_row,:); %ѡȡһ������ 
                outw_ru=unique(outw_row); %���е���������
                outw_mat=cell(length(outw_ru)+1,length(outw_cu)+1); %����ı�
                outw_mat{1,1}='��λ';
                for cu=1:length(outw_cu) % ����ĸ�е�ÿһ������
                    Tag_c=outw_cu{cu}; % ĸ����һ���͵�Tag
                    outw_mat{1,cu+1}=Tag_c; % �������ĸ�е�����Tag
                    for ru=1:length(outw_ru) %�������е�ÿһ������
                        Tag_r=outw_ru{ru};
                        outw_mat{ru+1,1}=Tag_r;
                        log=zeros(1,length(outw_col)); %���log����ѡȡĸ��������Tag���͵�Ԫ��
                        for crt=1:length(log)
                            if isequal(outw_col{crt},Tag_c)
                                log(crt)=1;
                            end
                        end
                        outw_row_r=outw_row(logical(log)); %ѡȡ��Ӧĸ������Tagĸ�����͵����еĲ���
                        log_r=zeros(1,length(outw_row_r)); % ���log_r����ѡȡ����������Tag���͵�Ԫ��
                        for crt=1:length(log_r)
                            if isequal(outw_row_r{crt},Tag_r)
                                log_r(crt)=1;
                            end
                        end                    
                        outw_mat{ru+1,cu+1}=mean(find(log_r)); %����ĸ�е���Tag_c��������������е���Tag_r��ƽ��λ��
                    end
                end
                disp('==================================================================================================')
                disp(['����[',BLOCKS{outw_lev_col,1}{1},']��ÿһ������[',BLOCKS{outw_lev_row,1}{1},']��ÿһ�����͵�ƽ��λ�ã�'])
                disp(outw_mat);
            end
        end
    end
    
    
    
function output=bsliang_accumulator(input,acc,outmin,outmax) 
    %input��������������������output���������壬����������һ��ֵ�󷵻س�ʼֵ
    %��input�ۼ���acc��output��1
    
    output=floor((input-1)/acc)+outmin;
    output=bsliang_mod(output,outmax);
    
        %�������Ϊ���Դ��룺
%     for i=1:50
%         disp([num2str(i),' ',num2str(bsliang_accumulator(i,3,1,5))]);
%     end
%   �����������ľ��ǣ�1 1 1 2 2 2 3 3 3 4 4 4 5 5 5 1 1 1 2 2 2 3 3 3...