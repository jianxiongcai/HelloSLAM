% Find the shared feature points in three frames.

function correspondence = find_correspondence(points_A, points_B)

correspondence = [];

for iter = 1:size(points_A,2)
    X = points_A(4, iter);
    if find(X == points_B(1, :))
        label = find(X == points_B(1, :));
        correspondence = [correspondence [points_A(1:6, iter); points_B(4:6, label)]];
    end
end

end