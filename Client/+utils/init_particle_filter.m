function [particles] = init_particle_filter(numberOfParticles)
%INIT_PARTICLE_FILTER Prepares everything necessary for the particle
%filter.

% Particle format: x, y, w, ID
particles = zeros(numberOfParticles, 4);
maxX = 4000;
maxY = 4000;

% Initialisierung durch Gleichverteilung von Partikeln
for i = 1 : numberOfParticles
    % x, y, w, ID
    particles(i,:) = [(rand(1,1)*2-1)*maxX, (rand(1,1)*2-1)*maxY, 1/numberOfParticles, i];
end

end

