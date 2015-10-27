function [fitness] = checkWatermark(extWatermark,watermark)
fitness = extWatermark'*watermark(:,3)/sqrt(extWatermark'*extWatermark);
end