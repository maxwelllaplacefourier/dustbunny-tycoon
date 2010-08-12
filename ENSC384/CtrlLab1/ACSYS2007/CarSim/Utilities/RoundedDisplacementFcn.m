function [sys,x0,str,ts] = RoundedDisplacementFcn(t, x, u, flag, X, gw, Output, SampleTime)
% X = pulse magnitude
% gw = intensity factor*frequency
% Output = where 1 - position, 2 - velocity, 3 - acceleration
switch flag,
  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes(SampleTime);

  %%%%%%%%%%
  % Output %
  %%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u, X, gw, Output);

  %%%%%%%%%%%%%%%%
  % Unused flags %
  %%%%%%%%%%%%%%%%
  case { 1, 2, 4, 9 },
    sys = [];
    
  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end


%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(SampleTime)
%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
%
% initialize the initial conditions
%
x0  = [];
%
% str is always an empty matrix
%
str = [];
%
% inherited ts = [-1 0], continuous is [0 0]
%
ts  = [SampleTime 0];

%=============================================================================
% mdlOutputs
% Output the signal
%=============================================================================
%
function sys=mdlOutputs(t,x,u,X,gw,Output)
%  x = X*(1-(1+gwt)e^(-gwt))
%  x'' = X*g^2*w^2*(1-gwt)*e^(-gwt)
if Output == 1
    sys = X*(1-(1+gw*t)*exp(-gw*t));
elseif Output ==2
    sys = X*gw^2*t*exp(-gw*t);
elseif Output == 3
    sys = X*gw^2*(1-gw*t)*exp(-gw*t);
end

% end mdlUpdate