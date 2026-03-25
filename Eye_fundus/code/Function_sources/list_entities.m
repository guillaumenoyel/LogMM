%the strtok function can be used to parse a string list delimited by
%delimiter (e.g. a sentence into words).

% Guillaume NOYEL June 2021

function allEntities = list_entities(inputString,delimiter)
    remainder = inputString;
    allEntities = '';

    while (any(remainder))
      [chopped,remainder] = strtok(remainder,delimiter);
      allEntities = strvcat(allEntities, chopped);
    end
end