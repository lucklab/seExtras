classdef seCircle < handle
    %seCircle Stim Engine circle object that can then be drawn to the screen
    % via Psychtoolbox
    %
    %  obj = seCircle(locationPoint, width, height, frameWidth, frameColor, fillColor)
    % 
    % Example:
    %   rectangleObject = seCircle([500 200],200,100,10,'green', 'red'); 
    %   rectangleObject.show();
    %
    
    
    properties
        location
        width;          % Maximum width of a seCircle object's in pixels
        height;         % Maximum height of a seCircle object's in pixels
        frameWidth;     % Width of a seCircle object's frame in pixels
        frameColor;     % Color word of a seCircle object's frame
        fillColor;      % Color word of a seCircle object's fill (i.e. inner color)
        
    end
    

    properties(SetAccess = protected, Hidden = true)
        %                 In Psychtoolbox, cartesian coordinates (i.e. location-points) 
        %                 are defined as a two-element array with the following structure:
        %
        %                       [ x-coordinate y-coordinate ]
        %
        
        X = 1;          % array index for x-coordinates
        Y = 2;          % array index for x-coordinates
    end
    
    
    
    
    
    
    
    
    
    methods

        function obj    = seCircle(varargin)
        
            switch(nargin)
                
                case 0 % Default values if called with no arguments
                    obj.location    = [500 500];
                    obj.width       = 50;
                    obj.height      = 50;
                    obj.frameWidth  = 6;
                    obj.frameColor  = 'black';
                    obj.fillColor   = 'green';
                    
                case 1
                    
                    obj.location    = varargin{1};
                    obj.width       = 50;
                    obj.height      = 50;
                    obj.frameWidth  = 6;
                    obj.frameColor  = 'black';
                    obj.fillColor   = 'red';
                    
                case 2
                    
                    obj.location    = varargin{1};
                    obj.width       = 50;
                    obj.height      = 50;
                    obj.frameWidth  = 6;
                    obj.frameColor  = 'black';
                    obj.fillColor   = varargin{2};
                    
                case 6
                    obj.location    = varargin{1};
                    obj.width       = varargin{2};
                    obj.height      = varargin{3};
                    obj.frameWidth  = varargin{4};
                    obj.frameColor  = varargin{5};
                    obj.fillColor   = varargin{6};
                    
                otherwise
                    error('Wrong number of input arguments');
            end
            
            
        end % constructor method
                    
        function draw(obj, varargin)
     
            switch nargin
                case 2
                    winPtr          = varargin{1};
                case 3
                    winPtr          = varargin{1};
                    obj.location    = varargin{2};
                    
                otherwise
                    error('Wrong number in input arguments');
            end
            
            
            % Set the circle object's RECT
            frameRect   = [0    0   obj.height                  obj.width               ];              % Instead of filling one oval, you can also specify a list of multiple ovals to be
            fillRect    = [0    0   obj.height-obj.frameWidth   obj.width-obj.frameWidth];              % filled - this is much faster when you need to draw many objects per frame.
            
            % Set the circle object's LOCATION
            frameRect   = CenterRectOnPoint(frameRect, obj.location(obj.X), obj.location(obj.Y));
            fillRect    = CenterRectOnPoint(fillRect , obj.location(obj.X), obj.location(obj.Y));
            
            Screen('FillOval', winPtr                                               ...
                , [seColor2RGB(obj.frameColor)'     seColor2RGB(obj.fillColor)' ]   ...
                , [frameRect'                       fillRect'               ]   );
            

        end % method
        
        
        function show(obj)
            
            try

                [winPtr] = seSetupScreen(seColor2RGB('white'));
                Priority(MaxPriority(winPtr));

                tic;
                obj.draw(winPtr);
                toc;
                Screen('Flip', winPtr);     % flip/draw buffer to display monitor


                KbWait;
                Screen('CloseAll');         % close psychtoolbox screen
                Priority(0);

            catch matlab_err
                ShowCursor;
                Screen('CloseAll');                             % close psychtoolbox screen
                display(getReport(matlab_err));
            end
            
        end % method
        

    end % methods

end
