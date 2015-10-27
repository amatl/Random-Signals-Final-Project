function [Jout, watermark] = genApplyWatermark(J, watermarkLength, watermarkScale)
watermark = [getHighPoints(J,watermarkLength) randn(watermarkLength)];
Jout = J;
for val = watermark'
    Jout(val(1),val(2)) = J(val(1),val(2))*exp(watermarkScale*val(3));
end
end