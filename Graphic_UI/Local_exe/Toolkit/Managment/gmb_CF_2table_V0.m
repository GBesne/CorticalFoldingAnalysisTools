function [tbl,report] = gmb_CF_2table_V0(DT_path,report,CF_MD,Hemi_MD,Ses)

% Check if there is a sesion
ses_cnt = strcmp(Ses,'_*_');
if ~ses_cnt
    DT_path = fullfile(DT_path,Ses);
end

% Check the working mode
switch CF_MD
    case 1 % Lobewise analysis
        [tbl, corrupt] = extract_FreeSurferLobes_features_Vgmb(DT_path,...
            'hemi', Hemi_MD,'verbose',false,'atlas','FSDK');
        CF = 'Lobe';

    case 2 % Hemispherewise analysis
        [tbl, corrupt] = extract_FreeSurferHemi_features_Vgmb(DT_path,...
            'hemi', Hemi_MD,'verbose',false);
        CF = 'Hemipshere';

    case 3 % For the Scale implementation, TO DO

end

if sum(corrupt)==0
    % Message if all goes well
    aux = '      SUCCESS => ';
    if ~ses_cnt
        aux = [aux,Ses,'/'];
    end
    aux = [aux,CF,' estimations complete'];
    report = [report; string(aux)];

else
    % For the report message
    switch Hemi_MD
        case {"left","right"}
            Lobe_cod = Hemi_MD;
        otherwise
            Lobe_cod ={"left","right"};
    end

    % Error mesages if corrupted folders & Remove the nonvalid data
    for l=1:length(corrupt)
        if corrupt(l)
            % Report the issue
            aux = '      WARNING => ';
            if ~ses_cnt
                aux = [aux,Ses,'/'];
            end
            aux = [aux,Lobe_cod{l},' corrupted during ',CF,' estimation'];
            report = [report; string(aux)];

            switch Hemi_MD
                case {"avg","sum"}
                    ldx = strcmp(tbl.Hemisphere,Hemi_MD);

                otherwise
                    ldx = strcmp(tbl.Hemisphere,Lobe_cod{l});
            end
            tbl(ldx,:) = [];
        end
    end
end

