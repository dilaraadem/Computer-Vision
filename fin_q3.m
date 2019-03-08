clc;clear all;
t1=imread('t1.jpg');
t2=imread('t2.jpg');
t3=imread('t3.jpg');
t4=imread('t4.jpg');
t5=imread('t5.jpg');
t6=imread('t6.jpg');
te1=imread('te1.jpg');
te2=imread('te2.jpg');
te3=imread('te3.jpg');
% 
im1=getImg(t1,0.5);
im2=getImg(t2,0.5);
im3=getImg(t3,0.65);
im4=getImg(t4,0.5);
im5=getImg(t5,0.5);
im6=getImg(t6,0.7);
im7=getImg(te1,0.67);
im8=getImg(te2,0.67);
im9=getImg(te3,0.61);

choco(1)=detectchoco(im1,1); %choco1
choco(2)=detectchoco(im2,1);
choco(3)=detectchoco(im3,1);
choco(4)=detectchoco(im4,1);
choco(5)=detectchoco(im5,1);
choco(6)=detectchoco(im6,1);

test(1)=detectchoco(im7,1);
test(2)=detectchoco(im7,2);
test(3)=detectchoco(im7,3);
test(4)=detectchoco(im7,4);
test(5)=detectchoco(im8,1);
test(6)=detectchoco(im8,2);
test(7)=detectchoco(im8,3);
test(8)=detectchoco(im8,4);
test(9)=detectchoco(im8,5);
test(10)=detectchoco(im9,1);
test(11)=detectchoco(im9,2);
test(12)=detectchoco(im9,3);
test(13)=detectchoco(im9,4);

k=1;
for i=1:13
    for j=1:6
        a(i,j)=abs(test(i).Div-choco(j).Div);
        c(i,j)=abs(test(i).Perimeter-choco(j).Perimeter);
        if(a(i,j)<0.09 && c(i,j)<20 && c(i,j)>1)
            b(k).a=a(i,j);
            b(k).b=i;
            b(k).c=j;
            b(k).d=c(i,j);
            k=k+1;
            str1=["Chocolate " i " from test images "];
            str2=["Chocolate " j " from database"];
            str2=str2(1,1)+str2(1,2)+str2(1,3);
            str1=str1(1,1)+str1(1,2)+str1(1,3);
            str=str1 + "is detected as " +str2;
            disp(str);
            figure;
            subplot(1,2,1)
            imshow(test(i).image);
            title(str1); 
            subplot(1,2,2)           
            imshow(choco(j).image);
            title(str2);
        end
    end
end

function[m]=detectchoco(im1,a)
im=im1(a).target;
cc=bwconncomp(im,8);
n=cc.NumObjects;
k=regionprops(cc,'Area','Perimeter','MajorAxisLength','MinorAxisLength');
for i=1:n
    m(i).Area=k(i).Area;
    m(i).Perimeter=k(i).Perimeter;
    m(i).MajorAxis=k(i).MajorAxisLength;
    m(i).MinorAxis=k(i).MinorAxisLength;
    m(i).Div=(m(i).MajorAxis/m(i).MinorAxis);
    m(i).image=im;
end
end

function[store]=getImg(t,thres)
t1=imcrop(t,[26 7 size(t,2) size(t,1)]);
t1bw=binarize(t1,thres);
label=bwlabel(t1bw);
%     figure;imshow(t1bw);
k=1;
for j=1:max(max(label))
    [row,col]=find(label==j);
    target=uint8(zeros([(max(row)-min(row)+2) (max(col)-min(col)+2)])); %empty matrix
    sy=min(col)-1;
    sx=min(row)-1;
    for i=1:size(row,1)
        x=row(i,1)-sx;
        y=col(i,1)-sy;
        target(x,y)=t1(row(i,1),col(i,1));
    end
    store(k).target=target; %store is the struct to store target images
    k=k+1; %go for the next struct
%     figure;imshow(target);
end
end
function[tbw]=binarize(t1,thres)
t1=rgb2gray(t1);
t1bw=imbinarize(t1,thres);
t1bw=imcomplement(t1bw);
t1bw=imfill(t1bw,'holes');
se=strel('disk',5);
tbw=imopen(t1bw,se);
end