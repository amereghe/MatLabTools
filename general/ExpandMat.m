function NewMat=ExpandMat(ExistMat,AppMat,lForce)
    if (~exist("lForce","var")), lForce=false; end
    if ( ismissing(ExistMat) )
        % first time we append data
        NewMat=AppMat;
    else
        eNdims=ndims(ExistMat); eSize=size(ExistMat);
        aNdims=ndims(AppMat);   aSize=size(AppMat);
        % NB:
        % - iDimApp: outermost dimension of final matrix;
        % - [jDimApp:kDimApp]: indices taken by appended data in outermost dimension;
        if ( eNdims==aNdims )
            % second time we append data: the outermost dimension of the
            %   existing matrix is 1;
            % in fact, the number of dimensions is the same between the
            %   existing matrix and the one to be appended
            if ( lForce )
                % expand existing matrix without increasing number of dimensions
                iDimApp=eNdims;
                jDimApp=eSize(end)+1;
                kDimApp=eSize(end)+aSize(end);
            else
                if ( eNdims==2 && aSize(2)==1 )
                    % actually append an array and build a matrix
                    iDimApp=eNdims;
                    kDimApp=eSize(end)+1;
                else
                    % append an N-dim matrix
                    iDimApp=eNdims+1;
                    kDimApp=2; % jDim==1 corresponds to the existing matrix
                end
               jDimApp=kDimApp;
            end
        elseif ( eNdims==aNdims+1 )
            % append an N-dim matrix
            iDimApp=eNdims;
            kDimApp=eSize(end)+1;
            jDimApp=kDimApp;
        else
            error("eNdims~=aNdims && eNdims~=aNdims+1");
        end
        switch iDimApp
            case 2
                % init matrix to be returned
                if ( isstring(AppMat) )
                    NewMat=strings(max(eSize(1),aSize(1)),kDimApp);
                    NewMat(:,:)=missing();
                else
                    NewMat=NaN(max(eSize(1),aSize(1)),kDimApp);
                end
                % store existing data
                NewMat(1:eSize(1),1:jDimApp-1)=ExistMat;
                % store new data
                NewMat(1:aSize(1),jDimApp:kDimApp)=AppMat;
            case 3
                % init matrix to be returned
                if ( isstring(AppMat) )
                    NewMat=strings(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),kDimApp);
                    NewMat(:,:,:)=missing();
                else
                    NewMat=NaN(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),kDimApp);
                end
                % store existing data
                NewMat(1:eSize(1),1:eSize(2),1:jDimApp-1)=ExistMat;
                % store new data
                NewMat(1:aSize(1),1:aSize(2),jDimApp:kDimApp)=AppMat;
            case 4
                % init matrix to be returned
                if ( isstring(AppMat) )
                    NewMat=strings(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),kDimApp);
                    NewMat(:,:,:,:)=missing();
                else
                    NewMat=NaN(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),kDimApp);
                end
                % store existing data
                NewMat(1:eSize(1),1:eSize(2),1:eSize(3),1:jDimApp-1)=ExistMat;
                % store new data
                NewMat(1:aSize(1),1:aSize(2),1:aSize(3),jDimApp:kDimApp)=AppMat;
            case 5
                % init matrix to be returned
                if ( isstring(AppMat) )
                    NewMat=strings(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),max(eSize(4),aSize(4)),kDimApp);
                    NewMat(:,:,:,:,:)=missing();
                else
                    NewMat=NaN(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),max(eSize(4),aSize(4)),kDimApp);
                end
                % store existing data
                NewMat(1:eSize(1),1:eSize(2),1:eSize(3),1:eSize(4),1:jDimApp-1)=ExistMat;
                % store new data
                NewMat(1:aSize(1),1:aSize(2),1:aSize(3),1:aSize(4),jDimApp:kDimApp)=AppMat;
            case 6
                % init matrix to be returned
                if ( isstring(AppMat) )
                    NewMat=strings(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),max(eSize(4),aSize(4)),...
                        max(eSize(5),aSize(5)),kDimApp);
                    NewMat(:,:,:,:,:,:)=missing();
                else
                    NewMat=NaN(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),max(eSize(4),aSize(4)),...
                        max(eSize(5),aSize(5)),kDimApp);
                end
                % store existing data
                NewMat(1:eSize(1),1:eSize(2),1:eSize(3),1:eSize(4),1:eSize(5),1:jDimApp-1)=ExistMat;
                % store new data
                NewMat(1:aSize(1),1:aSize(2),1:aSize(3),1:aSize(4),1:aSize(5),jDimApp:kDimApp)=AppMat;
            case 7
                % init matrix to be returned
                if ( isstring(AppMat) )
                    NewMat=strings(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),max(eSize(4),aSize(4)),...
                        max(eSize(5),aSize(5)),max(eSize(6),aSize(6)),kDimApp);
                    NewMat(:,:,:,:,:,:,:)=missing();
                else
                    NewMat=NaN(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),max(eSize(4),aSize(4)),...
                        max(eSize(5),aSize(5)),max(eSize(6),aSize(6)),kDimApp);
                end
                % store existing data
                NewMat(1:eSize(1),1:eSize(2),1:eSize(3),1:eSize(4),1:eSize(5),1:eSize(6),1:jDimApp-1)=ExistMat;
                % store new data
                NewMat(1:aSize(1),1:aSize(2),1:aSize(3),1:aSize(4),1:aSize(5),1:aSize(6),jDimApp:kDimApp)=AppMat;
            case 8
                % init matrix to be returned
                if ( isstring(AppMat) )
                    NewMat=strings(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),max(eSize(4),aSize(4)),...
                        max(eSize(5),aSize(5)),max(eSize(6),aSize(6)),max(eSize(7),aSize(7)),kDimApp);
                    NewMat(:,:,:,:,:,:,:,:)=missing();
                else
                    NewMat=NaN(max(eSize(1),aSize(1)),max(eSize(2),aSize(2)),max(eSize(3),aSize(3)),max(eSize(4),aSize(4)),...
                        max(eSize(5),aSize(5)),max(eSize(6),aSize(6)),max(eSize(7),aSize(7)),kDimApp);
                end
                % store existing data
                NewMat(1:eSize(1),1:eSize(2),1:eSize(3),1:eSize(4),1:eSize(5),1:eSize(6),1:eSize(7),1:jDimApp-1)=ExistMat;
                % store new data
                NewMat(1:aSize(1),1:aSize(2),1:aSize(3),1:aSize(4),1:aSize(5),1:aSize(6),1:aSize(7),eSize(end)+1:kDimApp)=AppMat;
            otherwise
                error("please increase number of dimensions treated!");
        end
    end
end
