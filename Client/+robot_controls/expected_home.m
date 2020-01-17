function [home, particles] = expected_home(particles, measurement, trans, rot, bodyfig)
%FIND_HOME Summary of this function goes here
% Particles initialized outside
% Measurement on current position
% Motion is robot movement to new position
sigmaMeasurement = 50;
mutateRandoms = 0;
mutatePos = 50;
potSize = 10000;


trans
% Move each particle CONTRARY to robot motion
% First rot then trans
for i = 1 : length(particles)
    particles(i, 1:2) = motion(particles(i, 1:2), rot, trans);
end

% Calculate measurement to each particle
particleDist = zeros(size(particles(:, 1)));
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
particles = gen;
% Calculate estimated home
home = ransac(particles(:, 1:2));
end

function [point] = motion(point, angle, trans)
% Angle must be in degrees

% Define the rotation matrix
H = [   cosd(angle) -sind(angle) trans(1);
        sind(angle)  cosd(angle) trans(2);
            0           0           1];
    

temp_point = [inv(H) * [point, 1]']';

point = temp_point(1:2);
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

function [pos_est] = ransac(particles)
%RANSAC Summary of this function goes here
%   Detailed explanation goes here
iterations = 10;
range = 1;


bestPos = 0;
neighbours = 0;

for i = 1 : iterations
    particlesInRange = [];
    % Choose one of the points randomly
    r = floor(rand()*size(particles, 1))+1;
    particle = particles(r, :);
    
    for p = 1 : size(particles, 1)
        % Wenn die distanz kleiner als range --> nachbar
        if eucl_dist(particle(1,1:2), particles(p, 1:2)) < range
            particlesInRange = [particlesInRange; particles(p,:)];
        end
    end
    if neighbours < size(particlesInRange, 1)
        neighbours = size(particlesInRange, 1);
        bestPos = mean_pos(particlesInRange(:, 1:2));
    end
end

pos_est = bestPos';

end

function pos = mean_pos(positions)
x = mean(positions(:, 1));
y = mean(positions(:, 2));

pos = [x; y];
end

