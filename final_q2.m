clc; clear all;
I=imread('clock005.jpg');
Igray=rgb2gray(I);

Ifilt=imgaussfilt(Igray,2.5); %get rid of unnecessary details

% figure;imshow(Ifilt);
BW=edge(Ifilt,'canny'); %get binary image
% figure;imshow(BW);

[H,T,R]=hough(BW);
figure;imshow(H,[],'XData',T,'YData',R,...
    'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);

P  = houghpeaks(H,3,'threshold',ceil(0.6*max(H(:)))); %3 peak points
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');

%detect lines aka arms of the clock
lines = houghlines(BW,T,R,P,'FillGap',10,'MinLength',50); %ignore the lines shorter than 50, combine the lines which has distence less than 10
figure, imshow(Igray), hold on
max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    % Plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    % Determine the endpoints of the longest line segment
    len = norm(lines(k).point1 - lines(k).point2);
    if ( len > max_len)
        max_len = len;
        xy_long = xy;
    end
end
[centers, radii]=imfindcircles(Igray,[140 200],'ObjectPolarity','dark','Sensitivity',0.98);%detect the clock circle
viscircles(centers,radii);

long=lines(1);
short=lines(2);

angle_short=short.theta;
angle_long=long.theta;

p1short=short.point1;
p1long=long.point1;

hour=oclock(angle_short,p1short,centers); %find hour
minute=findminute(angle_long,p1long,centers); %find minute
if(minute==0)
    minute="00";
end
arr=["Time is " hour ":" minute];
arr=arr(1,1)+arr(1,2)+arr(1,3)+arr(1,4);
title(arr);%display the hour
hold off;
function[clock]=oclock(angle,p1,center)
if(p1(1)<center(1)) %6789,10,11
    if(angle>=0 && angle<30)
        clock="6";
    elseif(angle>=30 && angle<60)
        clock="7";
    elseif(angle>=60 && angle<90)
        clock="8";
    elseif(angle>=90 && angle<120)
        clock="9";
    elseif(angle>=120 && angle<150)
        clock="10";
    elseif(angle>=150 && angle<180)
        clock="11";
    elseif(angle==180)
        clock="12";
    end
else %12,12345
    if(angle>=0 && angle<30)
        clock="12";
    elseif(angle>=30 && angle<60)
        clock="1";
    elseif(angle>=60 && angle<90)
        clock="2";
    elseif(angle>=90 && angle<120)
        clock="3";
    elseif(angle>=120 && angle<150)
        clock="4";
    elseif(angle>=150 && angle<180)
        clock="5";
    elseif(angle==180)
        clock="6";
    end
end
end

function[minute]=findminute(angle,p1,centers)
if(p1(1)<centers(1))
    if(angle==-1)
        minute=30;
    else
    minute=(-angle-1)/6;
    minute=60-minute;
    minute=floor(minute);
    end
else
    if(angle==-1)
        minute=0;
    else
    minute=(-angle-1)/6;
    minute=30-minute;
    minute=round(minute);
    end
end
end

