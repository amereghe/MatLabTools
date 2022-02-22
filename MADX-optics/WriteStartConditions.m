function WriteStartConditions(betx,alfx,bety,alfy,x,xp,y,yp,dx,dpx,dy,dpy,emiGx,emiGy)
% WriteStartConditions         to create a .opt file, with starting
%                                conditions of linear optics functions
% input:
% - all the linear optics functions that can be declared in a BETA0 MADX input block:
%   . betx/bety,x/y,dx/dy [m]: hor/ver beta functions, orbit and dispersion
%     functions;
%   . alfx/alfy,xp/yp,dpx/dpy []: hor/ver alpha functions, first derivative of orbit and
%     of dispersion functions;
%   . emiGx/emiGy [pi m rad]: hor/ver geometric emittances;
%
    oFileName="start-conditions_matlab.opt";
    lFileName="start-conditions_matlab.log";
    labelName="initial";
    if ( ~exist('emiGx','var') ), emiGx=NaN(); end
    if ( ~exist('emiGy','var') ), emiGy=NaN(); end
    
    % actually writing
    fprintf("writing updated starting opstics conditions to file %s ...\n",oFileName);
    oFile=fopen(oFileName,'w');
    fprintf(oFile,"%s: BETA0,\n",labelName);
    fprintf(oFile,"     betx = %.6f,\n",betx);
    fprintf(oFile,"     alfx = %.6f,\n",alfx);
    fprintf(oFile,"     bety = %.6f,\n",bety);
    fprintf(oFile,"     alfy = %.6f,\n",alfy);
    fprintf(oFile,"     dx = %.6e,\n",dx);
    fprintf(oFile,"     dpx = %.6e,\n",dpx);
    fprintf(oFile,"     dy = %.6e,\n",dy);
    fprintf(oFile,"     dpy = %.6e,\n",dpy);
 	fprintf(oFile,"     x=%.6e,\n",x);
 	fprintf(oFile,"     px=%.6e,\n",xp);
 	fprintf(oFile,"     y=%.6e,\n",y);
 	fprintf(oFile,"     py=%.6e;\n",yp);
    fclose(oFile);
    
    % logging
    fprintf("...logging to file %s ...\n",lFileName);
    oFile=fopen(lFileName,'a');
    fprintf(oFile,"% .6f,% .6f,% .6e,% .6f,% .6f,% .6e,% .6e,% .6e,% .6e,% .6e,% .6e,% .6e,% .6e,% .6e\n",...
            betx,alfx,emiGx,bety,alfy,emiGy,x,xp,y,yp,dx,dpx,dy,dpy);
    fclose(oFile);
    
    % 
    fprintf("...done.\n");
end

