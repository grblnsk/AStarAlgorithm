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

classdef MinHeap < Heap
%--------------------------------------------------------------------------
% Class:        MinHeap < Heap (& handle)
%               
% Constructor:  H = MinHeap(n);
%               H = MinHeap(n,x0);
%               
% Properties:   (none)
%               
% Methods:                 H.InsertKeyValuePair([key value]);
%               sx       = H.Sort();
%               min      = H.ReturnMin();
%               min      = H.ExtractMin();
%               count    = H.Count();
%               capacity = H.Capacity();
%               bool     = H.IsEmpty();
%               bool     = H.IsFull();
%                          H.Clear();
%               min      = H.ExtractMinKey()
% Description:  This class implements a min-heap of numeric keys
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         January 16, 2014
%--------------------------------------------------------------------------
% -> Edited to accept [key,value] pair. Jacek Garbulinski, 2020

    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = MinHeap(varargin)
            %----------------------- Constructor --------------------------
            % Syntax:       H = MinHeap(n);
            %               H = MinHeap(n,x0);
            %               
            % Inputs:       n is the maximum number of keys that H can hold
            %               
            %               x0 is a vector (of length <= n) of numeric keys
            %               to insert into the heap during initialization
            %               
            % Description:  Creates a min-heap with capacity n
            %--------------------------------------------------------------
            
            % Call base class constructor
            this = this@Heap(varargin{:});
            
            % Construct the min heap
            this.BuildMinHeap();
        end
        
        %
        % Insert key
        %
        function InsertKeyValuePair(this,keyValuePair)
            %------------------------ InsertKey ---------------------------
            % Syntax:       H.InsertKey(key);
            %               
            % Inputs:       key is a number
            %               
            % Description:  Inserts key into H
            %--------------------------------------------------------------
            
            this.SetLength(this.k + 1);
            this.X(this.k,:) = inf;
            this.DecreaseKey(this.k,keyValuePair);
        end
        
        function InsertNode(this,keyValuePair)
            InsertKeyValuePair(this,keyValuePair)
        end
        %
        % Sort the heap
        %
        function sx = Sort(this)
            %-------------------------- Sort ------------------------------
            % Syntax:       sx = H.Sort();
            %               
            % Outputs:      sx is a vector taht contains the sorted
            %               (ascending order) keys in H
            %               
            % Description:  Returns the sorted values in H
            %--------------------------------------------------------------
            
            % Sort the heap
            nk = this.k; % virtual heap size during sorting procedure
            for i = this.k:-1:2
                this.Swap(1,i);
                nk = nk - 1;
                this.MinHeapify(1,nk);
            end
            this.X(1:this.k,:) = flipud(this.X(1:this.k,:));
            sx = this.X(1:this.k,:);
        end
        
        %
        % Return minimum element
        %
        function min = ReturnMin(this)
            %------------------------ ReturnMin ---------------------------
            % Syntax:       min = H.ReturnMin();
            %               
            % Outputs:      min is the minimum key in H
            %               
            % Description:  Returns the minimum key in H
            %--------------------------------------------------------------
            
            if (this.IsEmpty() == true)
                min = [];
            else
                min = this.X(1,:);
            end
        end
        
        %
        % Extract minimum element
        %
        function min = ExtractMin(this)
            %------------------------ ExtractMin --------------------------
            % Syntax:       min = H.ExtractMin();
            %               
            % Outputs:      min is the minimum key in H
            %               
            % Description:  Returns the minimum key in H and extracts it
            %               from the heap
            %--------------------------------------------------------------
            
            this.SetLength(this.k - 1);
            min = this.X(1,:);
            this.X(1,:) = this.X(this.k + 1,:);
            this.MinHeapify(1);
        end
        
        function key = ExtractMinKey(this)
            keyValue = ExtractMin(this);
            key = keyValue(1);
        end
    end
    
    %
    % Private methods
    %
    methods (Access = private)
        %
        % Decrease key at index i
        %
        function DecreaseKey(this,i,keyValuePair)
            if (i > this.k)
                % Index overflow error
                MinHeap.IndexOverflowError();
            elseif (keyValuePair(1,2) > this.X(i,2))
                % Decrease key error
                MinHeap.DecreaseKeyError();
            end
            this.X(i,:) = keyValuePair;
            while ((i > 1) && (this.X(Heap.parent(i),2) > this.X(i,2)))
                this.Swap(i,Heap.parent(i));
                i = Heap.parent(i);
            end
        end
        
        %
        % Build the min heap
        %
        function BuildMinHeap(this)
            for i = floor(this.k / 2):-1:1
                this.MinHeapify(i);
            end
        end
        
        %
        % Maintain the min heap property at a given node
        %
        function MinHeapify(this,i,size)
            % Parse inputs
            if (nargin < 3)
                size = this.k;
            end
            
            ll = Heap.left(i);
            rr = Heap.right(i);
            if ((ll <= size) && (this.X(ll,2) < this.X(i,2)))
                smallest = ll;
            else
                smallest = i;
            end
            if ((rr <= size) && (this.X(rr,2) < this.X(smallest,2)))
                smallest = rr;
            end
            if (smallest ~= i)
                this.Swap(i,smallest);
                this.MinHeapify(smallest,size);
            end
        end
    end
    
    %
    % Private static methods
    %
    methods (Access = private, Static = true)
        %
        % Decrease key error
        %
        function DecreaseKeyError()
            error('You can only decrease keys in MinHeap');
        end
        
        %
        % Index overflow error
        %
        function IndexOverflowError()
            error('MinHeap index overflow');
        end
    end
end
