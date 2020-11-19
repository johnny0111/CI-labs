function varargout = pifuzzy(fismx, error, derror, Kerror, Kderror, Kdu, u1, ubound)

% Function PI-Fuzzy w/o antiwindup compensation
% Saturation implemented   
% Based on: bpfuzzyc(), by LBP, 2003-Mai-10
% Version 1.1
% By Paulo Gil, last update Nov./2020.


error(nargchk(8,8,nargin));
error(nargoutchk(1,1,nargout));

if size(ubound) ~= 2
    disp('Error: ubound is a vector [umin umax]!');
    return
else
    umin = ubound(1);
    umax = ubound(2);
end

error_n = Kerror * error;  % Normalized error to FIS
derror_n = Kderror * derror; % Normalized Derror to FIS
%dufis = evalfis([error_n derror_n], fismx); % Older Matlab versions
dufis = evalfis(fismx,[error_n derror_n]); % New Matlab versions
u_pi = u1 + Kdu * dufis;

% ********** Saturation ******************
u = min(max(u_pi,umin),umax); % Saturation [0 ,5] V


% ***************************************
varargout{1} = u;


% ************ EOF
% ************ Tested Nov. 2020: OK