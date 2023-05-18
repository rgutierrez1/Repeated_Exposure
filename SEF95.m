%% Function to calculate the SEF95 (Spectral edge 95)
% Copyright: Rodrigo Gutierrez, Depto. de Anestesiología, U. de Chile

function SEF_95 = SEF95(S,f)

    % INPUT
        % S: spectrum in uV2 (1D vector)
        % f: frequency vector
      
    % OUTPUT
        % SEF_95

% Normalized the power by total power
S_sum = sum(S);
S_norm = S./S_sum;
S_sum = cumsum(S_norm);
row95 = find(S_sum > 0.945 & S_sum < 0.955);
P95freq = f(1,row95);
SEF_95 = mean(P95freq);
end