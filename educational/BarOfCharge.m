bb=10; % [mm]
hh=1; % [mm]
FF=hh/bb;
theta=30; % [deg] [0:90]
C=2; % [C/mm/mrad]
theta_ref=rad2deg(atan(FF));
xdomain=-7:0.1:7;
% zlim=max(bb,hh)/2*1.1;

% define upright rectangle
%  D                 A
%    *-------------*
%    |             |
%    *-------------*
%  C                 B
x=[  bb/2  bb/2 -bb/2 -bb/2 ];
y=[  hh/2 -hh/2 -hh/2  hh/2 ];
% define rectangle rotate by 90 degs
R = [cosd(90) -sind(90); sind(90) cosd(90)];
xs=R(1,1)*x+R(1,2)*y;
ys=R(2,1)*x+R(2,2)*y;

% define rotation matrix
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% rotated points
xr=R(1,1)*x+R(1,2)*y;
yr=R(2,1)*x+R(2,2)*y;

% =========================================================================
ff=figure('Name','Rectangles','NumberTitle','off');
% =========================================================================
ax1=subplot('Position', [0.20, 0.25, 0.6, 0.7]);
% upright rectangle
patch(x,y,'r','FaceAlpha',0.3);
% rectangle rotated by 90 degs
patch(xs,ys,'b','FaceAlpha',0.3);
% rotated rectangle
patch(xr,yr,'g','FaceAlpha',0.3);
% decorators
xlim([min(xdomain) max(xdomain)]);
ylim([min(xdomain) max(xdomain)]);
% xlim([-zlim zlim]);
% ylim([-zlim zlim]);
grid on;
xlabel("x [mm]");
ylabel("px [mrad]");

ax2=subplot('Position', [0.20, 0.05, 0.6, 0.15]);
plot(xdomain,integralUp( xdomain, x, y, C ), 'r*-');
hold on;
plot(xdomain,integralUp( xdomain, xs, ys, C ), 'b*-');
hold on;
plot(xdomain,integralRot( xdomain, xr, yr, C, hh, bb, theta, theta_ref ), 'g*-');
xlim([min(xdomain) max(xdomain)]);
xlabel("x [mm]");
ylabel("int over px [C/mm]");
grid on;

linkaxes([ax1 ax2],'x');

% =========================================================================
ff=figure('Name','FWHM','NumberTitle','off');
% =========================================================================

% theta=0:0.1:90;
theta=0:0.1:360;
theta=theta;
% FWHM=bb*cosd(theta).*(theta<=90-theta_ref)+hh*sind(theta).*(theta>90-theta_ref);
FWHM=bb*sigmaPerturb(theta/360,FF,theta_ref/360);
plot(theta,FWHM,'*-');
hold on;
plot(90-[theta_ref theta_ref],[hh*sind(90-theta_ref) bb/2],'k-', ...
     90+[theta_ref theta_ref],[hh*sind(90-theta_ref) bb/2],'k-', ...
    270-[theta_ref theta_ref],[hh*sind(90-theta_ref) bb/2],'k-', ...
    270+[theta_ref theta_ref],[hh*sind(90-theta_ref) bb/2],'k-'  ...
);
grid on;
ylabel("FWHM [mm]");
xlabel("\theta [deg]");

function integral=integralUp( zz, xx, yy, C )
    integral=[];
    for z=zz
        if ( min(xx)<z & z<max(xx) )
            ret=C*(max(yy)-min(yy));
        else
            ret=0;
        end
%         fprintf("z=%g, ret=%g, bb=%g, -bb/2<z=%g, z>bb/2=%g \n",...
%             z,ret,bb,-bb/2<z,z>bb/2);
        integral=[integral ret];
    end
end

function integral=integralRot( zz, xx, yy, C, hh, bb, theta, theta_ref )
    if (0<=theta & theta<=90-theta_ref)
        xls=[xx(4) xx(3) xx(1) xx(2)];
        const=C*hh/cosd(theta);
    else
        xls=[xx(4) xx(1) xx(3) xx(2)];
        const=C*bb/sind(theta);
    end
    mU=-1/tand(theta);
    qU=yy(2)-mU*xx(2);
    mD=tand(theta);
    qD=yy(2)-mD*xx(2);
    integral=[];
    for z=zz
        if ( z<=xls(1) | z>=xls(4) )
            ret=0;
        elseif ( (xls(1)<z & z<xls(2)) | (xls(3)<z & z<xls(4)) )
            ret=C*(abs(z)*(mU-mD)+(qU-qD));
        else
            ret=const;
        end
        integral=[integral ret];
    end
end

function perturb=sigmaPerturb(theta,FF,theta_ref)
    % theta, theta_ref in units of 2pi
    theta_comp=rem(theta,1);
    indecesCos=( theta_comp<=1/4-theta_ref ...
        | (1/4+theta_ref<=theta_comp & theta_comp<=3/4-theta_ref ) ...
        | theta_comp>=3/4+theta_ref );
    indecesSin=( (1/4-theta_ref<theta_comp & theta_comp<1/4+theta_ref ) ...
        | (3/4-theta_ref<theta_comp & theta_comp<3/4+theta_ref ) );
    perturb=abs(cos(2*pi*theta_comp)).*indecesCos...
        +FF*abs(sin(2*pi*theta_comp)).*indecesSin;
end