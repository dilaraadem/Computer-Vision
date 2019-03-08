clc; clear all;
I=imread('beethoven_note.png');
I=rgb2gray(I);
I=imrotate(I,0.6); %rotate the sheeta little, since its not straight
I=imgaussfilt(I,0.2); 
figure;imshow(I); hold on

sol=storedata(109,130,I);
% figure;imshow(sol);title('sol');
mi=storedata(169,190,I);
% figure;imshow(mi);title('mi');
fa=storedata(341,362,I);
% figure;imshow(fa);title('fa');
re=storedata(403,424,I);
% figure;imshow(re);title('re');
do=storedata(568,589,I);
% figure;imshow(do);title('do');
I=double(I);
imdo=detect(do,I,90);
imre=detect(re,I,118);
immi=detect(mi,I,89);
imfa=detect(fa,I,70);
imsol=detect(sol,I,90);

plot(imdo(2:end,2),imdo(2:end,1),'LineStyle','none','LineWidth',2,'Marker','+','MarkerSize',10,'MarkerEdgeColor','y');
plot(imre(2:end,2),imre(2:end,1),'LineStyle','none','LineWidth',2,'Marker','+','MarkerSize',10,'MarkerEdgeColor','b');
plot(immi(2:end,2),immi(2:end,1),'LineStyle','none','LineWidth',2,'Marker','+','MarkerSize',10,'MarkerEdgeColor','m');
plot(imfa(2:end,2),imfa(2:end,1),'LineStyle','none','LineWidth',2,'Marker','+','MarkerSize',10,'MarkerEdgeColor','g');
plot(imsol(2:end,2),imsol(2:end,1),'LineStyle','none','LineWidth',2,'Marker','+','MarkerSize',10,'MarkerEdgeColor','r');

function[arr2] =detect(note,I,thres)
numnote=0;
k=0;
l=0;
arr2=zeros(1, 4);
for i=35:440
    for j=50:810
        mask=I(i-26:i+27, j-11:j+10);
%         figure;imshow(mask);
        k=k+1;
        im=floor(mask-note);
%         figure;imshow(im);
        [~,lim]=numdark(im); 
        if(lim<thres)
%             figure;imshow(im);
            if(l+1~=k)
                numnote=numnote+1;
                arr=[i j numnote lim];
                arr2=[arr2; arr];
            end
            l=k;
        end
    end
end
end

function[darkpixelnum,lightpixnum]=numdark(mask)
darkpixelnum=0;
lightpixnum=0;
[row, col]=size(mask);
for i=1:row
    for j=1:col
        if(mask(i,j)==0)
           darkpixelnum=darkpixelnum+1;
        else
           lightpixnum=lightpixnum+1;
        end
    end
end
end

function[note] =storedata(j1,j2,I)
note=zeros(54,22);
b=1;
for j=j1:j2
    a=1;
    for i=42:95
        note(a,b)=I(i,j);
        a=a+1;
    end
    b=b+1;
end
end

