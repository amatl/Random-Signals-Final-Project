function [Jout] = applyWatermark(J,watermark,watermarkPower)
Jout = J;
for val = watermark'
    Jout(val(1),val(2)) = J(val(1),val(2))*exp(watermarkPower*val(3));
end
end