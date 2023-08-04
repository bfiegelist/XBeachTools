function runup = Stockdon(Hs, Tp, slope)
   Lo = 9.81*Tp^2/(2*pi);
   runup = 1.1.*(.35.*slope.*(Hs.*Lo).^.5 + (((Hs.*Lo).*(.563.*slope.^2 + .004)).^.5)./2);
end