function correspondingValues = findCorrespondingValues(dataMatrix, targetValue)
%     % Find the row indices corresponding to the target value
%     rowIndices = find(dataMatrix(:, 1) == targetValue);
% 
%     % Check if the target value exists in the 1st column
%     if ~isempty(rowIndices)
%         % Get corresponding values from the 4th column
%         correspondingValues = dataMatrix(rowIndices, 4);
%         %fprintf('For P(%0.4f), corresponding values in the 2nd column are: %s\n', targetValue, num2str(correspondingValues));
%     else
%         %fprintf('Target value %0.4f not found in the 1st column.\n', targetValue);
%         correspondingValues = [];
%     end
% end

    % Find the indices of values in the first column greater than the target value
    greaterIndices = find(dataMatrix(:, 1) >= targetValue);
    
    if ~isempty(greaterIndices)
        % Find the index of the smallest value greater than the target value
        closestIndex = min(greaterIndices);
        
        % Get the corresponding value from the 4th column of the closest higher data point
        correspondingValues = dataMatrix(closestIndex, 4);
        
        %fprintf('For P(%0.4f), corresponding value in the 2nd column is: %0.4f\n', targetValue, correspondingValue);
    else
        %fprintf('No value found greater than %0.4f in the 1st column.\n', targetValue);
        correspondingValues = [];
    end
end

