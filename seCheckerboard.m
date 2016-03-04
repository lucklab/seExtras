classdef seCheckerboard < handle
    %seCheckerboard Stim Engine checkerboard object that can then be drawn to the screen
    % via Psychtoolbox
    %
    %  obj = seCheckerboard(locationPoint, boardWidth, boardHeight, tileSize, frameColor, tileColor)
    % 
    % Example:
    %   rectangleObject = seCheckerboard([500 200],200,100,10,'green', 'red'); 
    %   rectangleObject.show();
    %
    
    
    properties
        location
        boardWidth;         % (pixels) Maximum boardWidth  of a seCheckerboard object's in pixels
        boardHeight;        % (pixels) Maximum boardHeight of a seCheckerboard object's in pixels
        tileSize;           % (pixels) Width & height of a single tile (pixels)
        tileColor;          % (string) Color word of the (otherwise "white") tiles
    end
    

    properties(Hidden = true)
        image;
    end
    
    properties(SetAccess = protected, Hidden = true)
        %               In Psychtoolbox, cartesian coordinates (i.e. location-points) 
        %               are defined as a two-element array with the following structure:
        %               [ x-coordinate y-coordinate ]

        X = 1;          % array index for x-coordinate (for Psychtoolbox)
        Y = 2;          % array index for y-coordinate (for Psychtoolbox)
        
        tileRGB;
        ptTexture;
    end
    
    
    
    
    
    
    
    
    
    methods

        function obj    = seCheckerboard(varargin)
            % seCheckerboard(tileSize, boardWidth, boardHeight, tileColor)
        
            switch(nargin)
                
                case 0                                                  % Default values if seCheckerboard is called with no arguments
                    obj.boardWidth      = 10;                           % number of checker tiles across
                    obj.boardHeight     = 10;                           % number of checker tiles high
                    obj.tileSize        = 25;                           % size of each checker tile
                    obj.tileColor       = 'cyan';
                    winPtr              = false;
                    
                case 5
                    obj.tileSize        = varargin{1};
                    obj.boardWidth      = varargin{2};
                    obj.boardHeight     = varargin{3};
                    obj.tileColor       = varargin{4};
                    winPtr              = varargin{5};
                otherwise
                    error('Wrong number of input arguments');
            end
            
            obj.image           = (checkerboard(obj.tileSize, obj.boardHeight, obj.boardWidth) > 0.5) .* 255;
            obj.tileRGB         = seColor2RGB(obj.tileColor);

            if(winPtr)
                obj.load(winPtr);   % load 
            end
            
        end % constructor method
                    
        function load(obj, varargin)
            % Creates Psychtoolbox Texture object to draw to screen
            % example: seCheckerboardObject.load(winPtr)
     
            switch nargin
                case 2
                    winPtr          = varargin{1};
                otherwise
                    error('Wrong number in input arguments');
            end
            
            obj.ptTexture       = Screen('MakeTexture', winPtr, obj.image);

        end % method
        
        function draw(obj, varargin)
     
            switch nargin
                case 2
                    winPtr          = varargin{1};
                otherwise
                    error('Wrong number in input arguments');
            end
            
            Screen('DrawTexture', winPtr, obj.ptTexture,[],[],[],[],[], obj.tileRGB);

        end % method
        
        
        function show(obj)
            
            try

                [winPtr,~] = Screen(max(Screen('Screens')),'OpenWindow');
                obj.load(winPtr);
                
                tic;
                obj.draw(winPtr);
                toc;

                Screen('Flip', winPtr);     % flip/draw buffer to display monitor


                KbWait;
                Screen('CloseAll');         % close psychtoolbox screen

            catch matlab_err
                ShowCursor;
                Screen('CloseAll');                             % close psychtoolbox screen
                display(getReport(matlab_err));
            end
            
        end % method
        

    end % methods

end



