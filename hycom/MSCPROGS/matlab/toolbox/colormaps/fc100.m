function J=fc100(nbase)
%function J=fc100(nbase)
% fc100 color table
%
%  Similar to the color table used by Rainer Bleck 
%  Can be found in most of the NCAR-based tools of hycom
%

if nargin < 1
   nbase = size(get(gcf,'colormap'),1);
end

rgb=[ ...
   1.0000, 1.0000, 1.0000;
   0.9763, 0.9235, 0.9955;
   0.9567, 0.8603, 0.9918;
   0.9371, 0.7970, 0.9880;
   0.9175, 0.7338, 0.9843;
   0.8979, 0.6705, 0.9806;
   0.8783, 0.6073, 0.9769;
   0.8586, 0.5440, 0.9731;
   0.8390, 0.4808, 0.9694;
   0.8194, 0.4175, 0.9656;
   0.7998, 0.3543, 0.9619;
   0.7802, 0.2910, 0.9582;
   0.7606, 0.2278, 0.9544;
   0.7410, 0.1645, 0.9507;
   0.7241, 0.0380, 0.9736;
   0.6615, 0.0127, 0.9807;
   0.5988, 0.0000, 0.9860;
   0.5362, 0.0000, 0.9900;
   0.4892, 0.0000, 0.9900;
   0.4422, 0.0000, 0.9900;
   0.3800, 0.0000, 0.9900;
   0.3178, 0.0000, 0.9900;
   0.2556, 0.0000, 0.9900;
   0.1934, 0.0000, 0.9900;
   0.1312, 0.0000, 0.9702;
   0.0000, 0.0000, 0.9286;
   0.0030, 0.0287, 0.5463;
   0.0101, 0.1262, 0.2249;
   0.0217, 0.2002, 0.2851;
   0.0333, 0.2741, 0.3453;
   0.0537, 0.3375, 0.4587;
   0.0686, 0.3867, 0.5140;
   0.0803, 0.4279, 0.5393;
   0.0983, 0.4944, 0.5544;
   0.1221, 0.5670, 0.5852;
   0.1457, 0.6150, 0.6241;
   0.1692, 0.6629, 0.6629;
   0.1941, 0.7005, 0.7005;
   0.2190, 0.7382, 0.7382;
   0.2439, 0.7758, 0.7758;
   0.2892, 0.8330, 0.8330;
   0.3223, 0.8724, 0.8724;
   0.3567, 0.9080, 0.9080;
   0.3911, 0.9435, 0.9435;
   0.4317, 0.9800, 0.9800;
   0.3912, 0.9701, 0.9302;
   0.3478, 0.9537, 0.8740;
   0.2950, 0.9455, 0.7796;
   0.2442, 0.9291, 0.6784;
   0.2083, 0.9067, 0.6100;
   0.1755, 0.8390, 0.5624;
   0.1427, 0.7714, 0.5149;
   0.1113, 0.6867, 0.4606;
   0.0661, 0.6170, 0.3500;
   0.0530, 0.5317, 0.2928;
   0.0400, 0.4464, 0.2657;
   0.0282, 0.3873, 0.2226;
   0.0746, 0.4577, 0.1220;
   0.1522, 0.4797, 0.0000;
   0.1886, 0.5369, 0.0000;
   0.2021, 0.5941, 0.0000;
   0.2454, 0.6513, 0.0000;
   0.2903, 0.7080, 0.0000;
   0.3362, 0.7643, 0.0000;
   0.3901, 0.7873, 0.0000;
   0.4449, 0.8102, 0.0000;
   0.5006, 0.8330, 0.0000;
   0.5573, 0.8558, 0.0000;
   0.6150, 0.8785, 0.0000;
   0.6700, 0.9012, 0.0000;
   0.7334, 0.9238, 0.0000;
   0.8022, 0.9407, 0.0000;
   0.8774, 0.9480, 0.0000;
   0.9500, 0.9500, 0.0000;
   0.9150, 0.8946, 0.0000;
   0.8996, 0.8390, 0.0000;
   0.8996, 0.7797, 0.0000;
   0.8996, 0.7185, 0.0000;
   0.8996, 0.6570, 0.0000;
   0.8996, 0.5959, 0.0000;
   0.8996, 0.5350, 0.0000;
   0.8996, 0.4741, 0.0000;
   0.8996, 0.4132, 0.0000;
   0.8996, 0.3522, 0.0000;
   0.8996, 0.2913, 0.0000;
   0.8996, 0.2304, 0.0000;
   0.8996, 0.1695, 0.0000;
   0.8875, 0.1216, 0.0000;
   0.8754, 0.0736, 0.0000;
   0.8392, 0.0000, 0.0000;
   0.7820, 0.0000, 0.0000;
   0.7152, 0.0000, 0.0000;
   0.6499, 0.0000, 0.0000;
   0.5846, 0.0000, 0.0000;
   0.5092, 0.0000, 0.0000;
   0.4239, 0.0000, 0.0000;
   0.3386, 0.0000, 0.0000;
   0.2532, 0.0000, 0.0000;
   0.1679, 0.0000, 0.0000;
   0.1000, 0.0000, 0.0000 ];

rgb=rgb';

%size(rgb)
ncol=size(rgb,2);


J=[];
for i=1:nbase
   rind=(ncol-1)*(i-1)/(nbase-1);
   l0=max(1,min(floor(rind)+1,ncol-1));
   l1=l0+1;
   w0=l1-1-rind;
   w1=1.-w0;

   r=w0*rgb(1,l0)+w1*rgb(1,l1);
   g=w0*rgb(2,l0)+w1*rgb(2,l1);
   b=w0*rgb(3,l0)+w1*rgb(3,l1);
   J=[J ; r g b];
   %disp([num2str(i) ' '  num2str(rind) ' '  num2str(l0) ' '  num2str(w0) ])
end
