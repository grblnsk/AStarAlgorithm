% Copyright (c) 2014, Brian Moore
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% * Redistributions of source code must retain the above copyright notice, this
%   list of conditions and the following disclaimer.
% 
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% Modified by Jacek Garbulinski, April 2020

classdef Heap < handle
%
% Abstract superclass for all heap classes
%
% Note: You cannot instantiate Heap objects directly; use MaxHeap or
%       MinHeap
%
% -> Edited to accept [key,value] pair. Jacek G. 2020

    %
    % Protected properties
    %
    
    properties (Access = protected)
        k;                  % current number of elements
        n;                  % heap capacity
        X;                  % heap array
    end
    
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = Heap(n,x0)
            % Initialize heap
            if (n == 0)
                Heap.ZeroCapacityError();
            end
            this.n = n;
            this.X = nan(n,2);
            
            if ((nargin == 2) && ~isempty(x0))
                % Insert given elements
                k0 = numel(x0(:,2));
                if (k0 > n)
                    % Heap overflow
                    Heap.OverflowError();
                else
                    this.X(1:k0,1) = x0(:,1);
                    this.X(1:k0,2) = x0(:,2);
                    
                    this.SetLength(k0);
                end
            else
                % Empty heap
                this.Clear();
            end
        end
        
        %
        % Return number of elements in heap
        %
        function count = Count(this)
            %-------------------------- Count -----------------------------
            % Syntax:       count = H.Count();
            %               
            % Outputs:      count is the number of values in H
            %               
            % Description:  Returns the number of values in H
            %--------------------------------------------------------------
            
            count = this.k;
        end
        
        %
        % Return heap capacity
        %
        function capacity = Capacity(this)
            %------------------------- Capacity ---------------------------
            % Syntax:       capacity = H.Capacity();
            %               
            % Outputs:      capacity is the size of H
            %               
            % Description:  Returns the maximum number of values that can 
            %               fit in H
            %--------------------------------------------------------------
            
            capacity = this.n;
        end
        
        %
        % Check for empty heap
        %
        function bool = IsEmpty(this)
            %------------------------- IsEmpty ----------------------------
            % Syntax:       bool = H.IsEmpty();
            %               
            % Outputs:      bool = {true,false}
            %               
            % Description:  Determines if H is empty
            %--------------------------------------------------------------
            
            if (this.k == 0)
                bool = true;
            else
                bool = false;
            end
        end
        
        %
        % Check for full heap
        %
        function bool = IsFull(this)
            %-------------------------- IsFull ----------------------------
            % Syntax:       bool = H.IsFull();
            %               
            % Outputs:      bool = {true,false}
            %               
            % Description:  Determines if H is full
            %--------------------------------------------------------------
            
            if (this.k == this.n)
                bool = true;
            else
                bool = false;
            end
        end
        
        %
        % Clear the heap
        %
        function Clear(this)
            %-------------------------- Clear -----------------------------
            % Syntax:       H.Clear();
            %               
            % Description:  Removes all values from H
            %--------------------------------------------------------------
            
            this.SetLength(0);
        end
    end
    
    %
    % Abstract methods
    %
    methods (Abstract)
        %
        % Sort elements
        %
        Sort(this);
        
        %
        % Insert key
        %
        InsertKeyValuePair(this,keyValuePair);
    end
    
    %
    % Protected methods
    %
    methods (Access = protected)
        %
        % Swap elements
        %
        function Swap(this,i,j)
            val = this.X(i,:);
            this.X(i,:) = this.X(j,:);
            this.X(j,:) = val;
        end
        
        %
        % Set length
        %
        function SetLength(this,k)
            if (k < 0)
                Heap.UnderflowError();
            elseif (k > this.n)
                Heap.OverflowError();
            end
            this.k = k;
        end
    end
    
    %
    % Protected static methods
    %
    methods (Access = protected, Static = true)
        %
        % Parent node
        %
        function p = parent(i)
            p = floor(i / 2);
        end
        
        %
        % Left child node
        %
        function l = left(i)
            l = 2 * i;
        end
        
        % Right child node
        function r = right(i)
            r = 2 * i + 1;
        end
        
        %
        % Overflow error
        %
        function OverflowError()
            error('Heap overflow');
        end
        
        %
        % Underflow error
        %
        function UnderflowError()
            error('Heap underflow');
        end
        
        %
        % No capacity error
        %
        function ZeroCapacityError()
            error('Heap with no capacity is not allowed');
        end
    end
end
