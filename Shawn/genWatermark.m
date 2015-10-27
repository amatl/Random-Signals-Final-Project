function [watermark] = genWatermark(J,length)
watermark = [getHighPoints(J,length) randn(length,1)];
end