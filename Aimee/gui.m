function gui
close all;

   %  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','off','Position',[100,100,1600,1600]);
 
   % Create tab panels for audio and for images
   tgroup = uitabgroup('Parent', f);
   tab1 = uitab('Parent', tgroup, 'Title', 'Image');
   tab2 = uitab('Parent', tgroup, 'Title', 'Audio');
   
   %  Construct the components under tab 1, Image
   %  Position is [distance from left, distance from bottom, width, height]
   hloadimage = uicontrol('Parent',tab1,'Style','pushbutton','String','Load Image',...
          'Position',[50,700,100,25],...
          'Callback',{@loadimagebutton_Callback});
   happlywatermark_i = uicontrol('Parent',tab1,'Style','pushbutton','String','Apply Watermark',...
          'Position',[50,660,100,25],...
          'Callback',{@applywatermarkbutton_i_Callback});
   hextractwatermark_i = uicontrol('Parent',tab1,'Style','pushbutton',...
          'String','Extract Watermark',...
          'Position',[50,620,100,25],...
          'Callback',{@extractwatermarkbutton_i_Callback}); 
   htext_i = uicontrol('Parent',tab1,'Style','text','String','Signal Processing Operation',...
          'Position',[175,580,100,15]);
   hpopup_i = uicontrol('Parent',tab1,'Style','popupmenu',...
          'String',{'Filter','Crop','Compress'},...
          'Position',[150,540,100,25],...
          'Callback',{@popup_menu_i_Callback});
   hrefresh_i = uicontrol('Parent',tab1,'Style','pushbutton','String','Refresh Watermark',...
          'Position',[50,200,100,25],...
          'Callback',{@refreshbutton_i_Callback});
   haxis_i_original = axes('Parent', tab1, 'Units','pixels','Position',[240,300,300,300]);
   haxis_i_watermark = axes('Parent', tab1, 'Units','pixels','Position',[560,300,300,300]); 
   haxis_i_filter = axes('Parent', tab1, 'Units','pixels','Position',[880,300,300,300]);
   haxis_i_fitness = axes('Parent', tab1, 'Units','pixels','Position',[1200,300,300,300]);
   align([hloadimage,happlywatermark_i,hextractwatermark_i,htext_i,hpopup_i,hrefresh_i],'Center','None');
   
   
   %Construct the components under tab 2, Audio
   hloadaudio = uicontrol('Parent',tab1,'Style','pushbutton','String','Load Image',...
          'Position',[50,700,100,25],...
          'Callback',{@loadaudiobutton_Callback});
   happlywatermark_a = uicontrol('Parent',tab2,'Style','pushbutton','String','Apply Watermark',...
          'Position',[50,660,100,25],...
          'Callback',{@applywatermarkbutton_a_Callback});
   hextractwatermark_a = uicontrol('Parent',tab2,'Style','pushbutton',...
          'String','Extract Watermark',...
          'Position',[50,620,100,25],...
          'Callback',{@extractwatermarkbutton_a_Callback}); 
   htext_a = uicontrol('Parent',tab1,'Style','text','String','Select Data',...
          'Position',[175,580,100,15]);
   hpopup_a = uicontrol('Parent',tab2,'Style','popupmenu',...
          'String',{'Filter','Crop','Compress'},...
          'Position',[150,540,100,25],...
          'Callback',{@popup_menu_a_Callback});
   hrefresh_a = uicontrol('Parent',tab2,'Style','pushbutton','String','Refresh Image',...
          'Position',[50,200,100,25],...
          'Callback',{@refreshbutton_a_Callback});
   haxis_a = axes('Parent', tab2, 'Units','pixels','Position',[300,200,500,500]);   
   align([hloadaudio,happlywatermark_a,hextractwatermark_a,htext_a,hpopup_a,hrefresh_a],'Center','None');
   
   % Initialize the GUI.
   % Change units to normalized so components resize 
   % automatically.
   set([f,hloadimage,happlywatermark_i,hextractwatermark_i,htext_i,hpopup_i,hloadaudio,happlywatermark_a,hextractwatermark_a,htext_a,hpopup_a],...
   'Units','normalized');
%TODO from this point on add audio stuff
   %Show Image 
    original_image = imread('Image2.jpg');
    imshow(original_image,'Parent',haxis_i_original);
    title('Original Image','Parent',haxis_i_original);
    %Initailize watermark
    watermarkLength = 1000;
    watermarkScale=0.05;
    watermarkedI = original_image;
    watermark = zeros(watermarkLength,3);
   % Assign the GUI a name to appear in the window title.
   set(f,'Name','Multimedia Watermarking')
   % Move the GUI to the center of the screen.
   movegui(f,'center')
   % Make the GUI visible.
   set(f,'Visible','on');
 
% Callbacks for tab 1, image
   % These callbacks automatically
   %  have access to component handles and initialized data 
   %  because they are nested at a lower level.
 
   %  Pop-up menu callback. Read the pop-up menu Value property
   %  to determine which item is currently displayed and make it
   %  the current data.
      function popup_menu_i_Callback(source,eventdata) 
         % Determine the selected data set.
         str = get(source, 'String');
         val = get(source,'Value');
         % Set current data to the selected data set.
         switch str{val};
         case 'Filter'
            watermarkedI = ntsc2rgb(imguidedfilter(watermarkedI));
            imshow(watermarkedI,'Parent',haxis_i_filter);
            title('Filtered Watermarked Image','Parent',haxis_i_filter);
            drawnow
         case 'Crop'
           watermarkedI = imcrop(watermarkedI);
           imshow(watermarkedI,'Parent',haxis_i_filter);
           title('Cropped Watermarked Image','Parent',haxis_i_filter);
           drawnow
         case 'Compress'
           watermarkedI = imresize(watermarkedI,0.5);
           imshow(watermarkedI,'Parent',haxis_i_filter);
           title('Compressed Watermarked Image','Parent',haxis_i_filter);
           drawnow
         end
      end
  
   % Push button callbacks. Each callback plots current_data in
   % the specified plot type.
 
   function loadimagebutton_Callback(source,eventdata) 
       % imshow(original_image);
       drawnow
       set(source,'Enable','off');
   end
 
   function applywatermarkbutton_i_Callback(source,eventdata)
       [watermarkedI, watermark]= genApplyWatermark(original_image,watermarkLength,watermarkScale);
        imshow(watermarkedI,'Parent',haxis_i_watermark);
        title('Watermarked Image','Parent',haxis_i_watermark);
        drawnow
        set(source,'Enable','off');
   end
 
   function extractwatermarkbutton_i_Callback(source,eventdata) 
        % Check watermark against a variety of generated ones
        extWatermark = extractWatermark(original_image,watermarkedI,watermark);
        fitnessChecks = 1000;
        fitnessPlot = zeros(fitnessChecks,1);
        randWatermark = watermark;
        for i=1:fitnessChecks
            if i == 100
                randWatermark(:,3) = watermark(:,3);
            else
                randWatermark(:,3) = randn(size(watermark,1),1);
            end
            fitnessPlot(i) = checkWatermark(extWatermark,randWatermark);
        end
        plot(fitnessPlot,'Parent',haxis_i_fitness);
        title('Fitness Plot','Parent',haxis_i_fitness);
        drawnow
   end

    function refreshbutton_i_Callback(source,eventdata)
        [watermarkedI, watermark]= genApplyWatermark(original_image,watermarkLength,watermarkScale);
        imshow(watermarkedI,'Parent',haxis_i_watermark);
        title('Watermarked Image','Parent',haxis_i_watermark);
        imshow(watermarkedI,'Parent',haxis_i_filter);
        title('Watermarked Image (No Signal Processing)','Parent',haxis_i_filter);
    end

%Callbacks for tab 2, audio

      function popup_menu_a_Callback(source,eventdata) 
         % Determine the selected data set.
         str = get(source, 'String');
         val = get(source,'Value');
         % Set current data to the selected data set.
         switch str{val};
         case 'Filter' 
         case 'Crop'
         case 'Compress'
         end
      end
 
   function loadaudiobutton_Callback(source,eventdata) 
   end
 
   function applywatermarkbutton_a_Callback(source,eventdata) 
  
   end
 
   function extractwatermarkbutton_a_Callback(source,eventdata) 
   end

   function refreshbutton_a_Callback(source,eventdata)
   end
 
end 