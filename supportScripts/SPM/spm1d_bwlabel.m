function [L,n] = spm1d_bwlabel(b)

Q      = numel(b);
d      = diff(b);
i0     = 1 + find(d==+1);
i1     = find(d==-1);

if b(1)
    i0 = [1 i0];
end
if b(end)
    i1 = [i1 numel(b)];
end

n      = numel(i0);
L      = zeros(1, Q);
for i=1:n
    L(i0(i):i1(i)) = i;
end

