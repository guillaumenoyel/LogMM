function [vXYCentre, rCuvature, bLigne, err_moy] = estimerCourbure(Pts_xy, MinRadius)
    % estimerCuvature estimates curvature based on a set of points.
    % Inputs:
    %   Pts_xy - Nx2 matrix of points (x, y)
    %   MinRadius - minimum radius for curvature estimation
    %
    % Outputs:
    %   vXYCentre - estimated center of the circle
    %   rCuvature - curvature radius
    %   bLigne - boolean indicating if a line is a better fit
    %   err_moy - average error of the fit

    % Extract x and y coordinates
    x = Pts_xy(:, 1);
    y = Pts_xy(:, 2);
    card = size(x, 1);

    % Step 1: Estimate circle passing through the points
    mx = mean(x);
    my = mean(y);
    X = x - mx;
    Y = y - my;

    % Calculate necessary sums
    dx2 = mean(X.^2);
    dy2 = mean(Y.^2);
    vC = [X, Y] \ (X.^2 - dx2 + Y.^2 - dy2) / 2;
    vXYCentre = vC' + [mx, my];
    r = sqrt(dx2 + dy2 + vC(1)^2 + vC(2)^2);

    % Step 2: Estimate the best fitting line using least squares
    if dy2 > dx2
        vab = [y, ones(card, 1)] \ x;
        a = -1;
        b = vab(1);
        c = vab(2);
    else
        vab = [x, ones(card, 1)] \ y;
        a = vab(1);
        b = -1;
        c = vab(2);
    end

    % Calculate distances to the line and circle
    vDistLine = abs(a * x + b * y + c) / sqrt(a^2 + b^2);
    vDistCircle = abs(r - sqrt((vXYCentre(1) - x).^2 + (vXYCentre(2) - y).^2));

    % Sum of distances
    s_Line = sum(vDistLine);
    s_Circle = sum(vDistCircle);

    % Determine if line or circle is a better fit
    if s_Line < s_Circle
        bLigne = true;
        rCuvature = 0;
        err_moy = s_Line / card;
    else
        bLigne = false;
        err_moy = s_Circle / card;
        rCuvature = (r < MinRadius) * (1 / MinRadius) + (r >= MinRadius) * (1 / r);

        % Determine curvature sign
        angle1 = atan2(y(1) - vXYCentre(2), x(1) - vXYCentre(1)) * 180 / pi;
        angleEnd = atan2(y(end) - vXYCentre(2), x(end) - vXYCentre(1)) * 180 / pi;

        if abs(angle1 - angleEnd) < 180
            Cuvature_sign = sign(angleEnd - angle1);
        else
            angle1 = mod(angle1 + 360, 360);
            angleEnd = mod(angleEnd + 360, 360);
            Cuvature_sign = sign(angleEnd - angle1);
        end

        rCuvature = rCuvature * Cuvature_sign;
    end
end