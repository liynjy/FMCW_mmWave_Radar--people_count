%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                FMCW Radar Simulator               %
%                                                   %
% Author: Lin Junyang                               %
% Email : linjy@163.com                             %
% Date  : 2020-3-14                                 %
%                                                   %
% All Rights Reserved.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
if ~exist('I1','var') || ~exist('Q1','var') || ~exist('I2','var') || ~exist('Q2','var') || ...
        ~exist('TargetTracks','var')
    [I1,Q1,I2,Q2,TargetTracks] = radar_simulation_wrapper;
    close all
end

[TotalChirpNum,ChirpLen] = size(I1);

rx1_c = I1 + Q1*1j;
rx2_c = I2 + Q2*1j;

%%
% Range FFT

if ~exist('RANGE_MIN','var')
    RANGE_MIN = 0;
end
if ~exist('RANGE_MAX','var')
    RANGE_MAX = 16;
end

rx1_range_fft = zeros(TotalChirpNum,1024);
rx2_range_fft = zeros(TotalChirpNum,1024);
tmp = zeros(1,ChirpLen);
for k=1:TotalChirpNum
    for m=1:ChirpLen
        tmp(m)=rx1_c(k,m)/((m+1)/ChirpLen)^0.3;
    end
    rx1_range_fft(k,:) = fft((tmp(301:1324)-mean(tmp(301:1324))).*hamming(1024)');
    
    for m=1:ChirpLen
        tmp(m)=rx2_c(k,m)/((m+1)/ChirpLen)^0.3;
    end
    rx2_range_fft(k,:) = fft((tmp(301:1324)-mean(tmp(301:1324))).*hamming(1024)');
end
rx1_range_fft(:,1:RANGE_MIN) = 0;
rx2_range_fft(:,1:RANGE_MIN) = 0;

eng_rx1_rfft = abs(rx1_range_fft(:,1:RANGE_MAX));
eng_rx2_rfft = abs(rx2_range_fft(:,1:RANGE_MAX));

%%
% Dopplor FFT
if ~exist('DPL_FFT_POINTS','var')
    DPL_FFT_POINTS = 32;
end
if ~exist('DPL_FFT_INTVERAL','var')
    DPL_FFT_INTVERAL = 32;
end
if ~exist('DPL_FFT_ELSIZE','var')
    DPL_FFT_ELSIZE = 128;
end

rx1_dpl_fft = zeros(DPL_FFT_ELSIZE,RANGE_MAX);
rx2_dpl_fft = zeros(DPL_FFT_ELSIZE,RANGE_MAX);

close all;
fh = figure;
pos = get(0,'ScreenSize');
pos(2) = pos(2)+45;
pos(3) = pos(3)*0.5;
pos(4) = pos(4)-130;
set(gcf,'Position',pos)
set(gcf,'colormap',cool)

SAVE_VIDEO = 0;
if SAVE_VIDEO==1
    video_file_name = '.\images&sim_video\multi_target_sim_result.avi';
    video_obj = VideoWriter(video_file_name);
    video_obj.FrameRate = fix(0.4*1000/DPL_FFT_INTVERAL);
    open(video_obj)
end

for chirp_idx=1:DPL_FFT_INTVERAL:TotalChirpNum-DPL_FFT_POINTS-DPL_FFT_INTVERAL
    rx1_rfft_clip = rx1_range_fft(chirp_idx:chirp_idx+DPL_FFT_POINTS-1,1:RANGE_MAX);
    rx2_rfft_clip = rx2_range_fft(chirp_idx:chirp_idx+DPL_FFT_POINTS-1,1:RANGE_MAX);
    rx1_rfft_clip(DPL_FFT_ELSIZE,:) = 0;
    rx2_rfft_clip(DPL_FFT_ELSIZE,:) = 0;

    for k=1:RANGE_MAX
        rx1_dpl_fft(:,k) = fftshift(fft(rx1_rfft_clip(:,k)));
        rx2_dpl_fft(:,k) = fftshift(fft(rx2_rfft_clip(:,k)));
    end

    eng_rx1_df = abs(rx1_dpl_fft);
    eng_rx2_df = abs(rx2_dpl_fft);

    eng_rx_df = eng_rx1_df.*eng_rx2_df;
    eng_rx_df = avg_filter_2D(eng_rx_df,1);

    for k=1:RANGE_MAX
        eng_rx_df(:,k)=eng_rx_df(:,k).*k^9;
    end

    for k=2:RANGE_MAX
        eng_rx_df(:,k-1)=eng_rx_df(:,k)-eng_rx_df(:,k-1);
    end
    eng_rx_df=-eng_rx_df(:,1:RANGE_MAX-1);
    eng_rx_df(eng_rx_df<(1e3+max(max(eng_rx_df))*1e-1))=0;
    
    for k=2:DPL_FFT_ELSIZE
        eng_rx_df(k-1,:)=eng_rx_df(k,:)-eng_rx_df(k-1,:);
    end
    eng_rx_df=-eng_rx_df(1:DPL_FFT_ELSIZE-1,:);
    eng_rx_df(eng_rx_df<(1e3+max(max(eng_rx_df))*1e-1))=0;
    
    eng_rx_pk = find_peaks_2D(eng_rx_df);
    eng_rx_pk = avg_filter_2D(eng_rx_pk,1);
    eng_rx_pk = erode_2D(eng_rx_pk,1);
    [eng_rx_df_bin,num] = erode_tobin_2D(eng_rx_pk);

    subplot(2,7,[1 2 3 4 5])
    surf(eng_rx_df);view(0,90);ylim([1,DPL_FFT_ELSIZE])
    caxis([0 inf]);
    axis off;
    title('Range-Velocity Map')

    subplot(2,7,[6 7])
    imshow(flipud(eng_rx_df_bin))
    title(['Target Count : ','\fontsize{16}\color{red}',num2str(num)]);
    
    subplot(20,1,11);axis off
    title('Radar Algorithm \uparrow')
    subplot(20,1,12)
    x=0:0.1:100;
    y=zeros(size(x));
    plot(x,y,'k:');ylim([-1 0.1]);axis off
    subplot(20,1,14);axis off
    title('Simulation to Generate FMCW Radar Signal \downarrow')
    
    subplot(3,2,5)
    img_room = imread('.\images&sim_video\room.png');
    imshow(img_room);
    title('Simulation: Room (4m*4m*2m)')
    
    subplot(3,2,6)
    for k = 1:target_num
    	plot(TargetTracks.X(k,chirp_idx*2000),TargetTracks.Y(k,chirp_idx*2000),'bo');hold on
    end
    hold off
    xlim([-2 2]);ylim([-2.5 2.5]);
    set(gca,'xtick',[],'xticklabel',[])
    set(gca,'ytick',[],'yticklabel',[])
    title('Simulation: Targets')

    pause(0.02)
    
    if SAVE_VIDEO==1
        frame = getframe(fh);
        writeVideo(video_obj,frame);
    end
end

if SAVE_VIDEO==1
    close(video_obj);
end







