function [out, particles] = expected_home(particles, measurement, trans, rot)
%FIND_HOME Summary of this function goes here
% Particles initialized outside
% Measurement on current position
% Motion is robot movement to new position
sigmaMeasurement = 100;
mutateRandoms = 20;
mutatePos = 200;
potSize = 10000;

% Move each particle CONTRARY to robot motion
% First rot then trans
for i = 1 : length(particles)
    particles(i, 1:2) = motion(particles(i, 1:2), -rot, -trans);
end

% Calculate measurement to each particle
particleDist = zeros(size(particles(:, 1)))
for i = 1 : length(particles)
    particleDist(i) = eucl_dist([0 0], particles(i, 1:2));
end

% Give a value to each particle 
for i = 1 : length(particles)
    particles(i, 3) = calc_weight(measurement, particleDist(i), sigmaMeasurement);
end

% Normalize the weights
particles(:,3) = particles(:, 3) / sum(particles(:, 3));

% Make new generation
% Resampling

pot = fill_pot(particles, potSize);
gen = make_generation(pot, size(particles,1));

gen = mutate(gen, mutatePos, mutateRandoms);

% Calculate estimated home
out = [sum(particles(:, 1)), sum(particles(:, 1))];
out = out / length(particles);

particles = gen;
end

function [point] = motion(point, angle, trans)
% Angle must be in degrees

% Define the rotation matrix
R = [   cosd(angle) -sind(angle);
        sind(angle)  cosd(angle)];

temp_point = R * point' + trans';

point = temp_point';
end

function dist = eucl_dist(left, right)
dist = sqrt((left(1) - right(1))^2 + (left(2) - right(2))^2);
end

function w = calc_weight(real_measurement, particle_measurement, sigma_measurement)
innovation = particle_measurement - real_measurement;
w = normpdf(innovation, 0, sigma_measurement);
end

function [pot] = fill_pot(particles, potSize)
%FILL_POTSummary of this function goes here
%   Detailed explanation goes here
%pot = zeros(potSize, 1);
pot = [];

for p = 1 : size(particles,1)
    i = 1;
    while i < potSize*particles(p, 3)
        pot = [pot; particles(p,:)];
        i = i + 1;
    end
end

end

function [gen] = make_generation(pot, genSize)
%MAKEGENERATION Summary of this function goes here
%   Detailed explanation goes here

gen = zeros(genSize, size(pot,2));
potSize = size(pot,1);

for p = 1 : genSize
    gen(p,:) = pot( floor(rand()*potSize) + 1, :);
    gen(p,3) = 1/genSize;
end

end

function [gen] = mutate(gen, xy, randomPoints)
%MUTATE Summary of this function goes here
%   Detailed explanation goes here
maxX = 4000;
maxY = 4000;

for p = 1 : size(gen,1)
    gen(p, 1) = gen(p, 1) + (rand(1)*2 - 1)*xy;
    gen(p, 2) = gen(p, 2) + (rand(1)*2 - 1)*xy;
end

for i = 1 : randomPoints
    r = floor( rand(1)*size(gen,1) ) + 1;
    gen(r,1:2) = [(rand(1)*2 - 1)*maxX; (rand(1)*2 - 1)*maxY];
end

end


