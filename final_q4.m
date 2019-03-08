clc;clear all;
I1=imread('Resim1.png');
I2=imread('Resim2.png');
I2=imgaussfilt(I2,2);
% figure;imshow(I1);
% figure;imshow(I2);

[im1,n1]=getImg(I1,0.6,6,1);
[im2,n2]=getImg(I2,0.6,7,2);

function[store,k]=getImg(t,thres,s,a)
t1bw=binarize(t,thres,s);
% figure;imshow(t1bw);
label=bwlabel(t1bw);
k=1;
for j=1:max(max(label))
    [row,col]=find(label==j);
    len=max(row)-min(row)+2;
    breadth=max(col)-min(col)+2;
    target=uint8(zeros([len breadth]));
    sy=min(col)-1;
    sx=min(row)-1;
    for i=1:size(row,1)
        x=row(i,1)-sx;
        y=col(i,1)-sy;
        target(x,y)=t(row(i,1),col(i,1));
    end
    store(k).target=target;
    k=k+1;
%     figure;imshow(target);
    leaf="Leaf number "+j + " from image "+a;
    title(leaf);
end
str="There are "+ j +" leaves in image " +a;
disp(str);
end
function[tbw]=binarize(t1,thres,s)
t1bw=imbinarize(t1,thres);
t1bw=imfill(t1bw,'holes');
se=strel('disk',s);
tbw=imopen(t1bw,se);
end