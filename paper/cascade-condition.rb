ITERATIONS = 69

def factorial(n)
  n == 0 ? 1 : n*factorial(n-1)
end

# Returns the propability that a node with degree k is vulerable for a homogenous threshold phi
def rho_homo(phi, k)
  return k == 0 || phi <= 1.to_f/k ? 1 : 0
end

# Returns the propability that a node has degree k for a poisson-distibiution of degrees with mean z
def p_poisson(z, k)
  (Math::E ** -z * z ** k) / factorial(k)
end

# That cryptic G_0''(1) function
def cascade(phi, z)
  (0..ITERATIONS).inject(0){ |sum, k| sum + k * (k - 1) * rho_homo(phi, k) * p_poisson(z, k) }
end

def cascade_condition(phi, z)
  cascade(phi, z) > z
end


puts "Cascade condition for z from 20 to 0 and phi from 0.1 to 0.3"
puts "██: Cascades possible. ░░: Cascades not possible"
puts

z = 20
while (z >= 0) do
  print sprintf('%02d', z)
  phi = 0.1
  while (phi <= 0.3) do
    print cascade_condition(phi, z) ? "██" : "░░"
    phi += 0.01
  end
  puts
  z -= 1
end
puts "  0.1                ...                0.3"


puts ""
puts "First iterations for z = 2 and phi=0.2"

7.times do |k|
  puts "#{k} * #{k-1} * #{rho_homo(0.2, k)} * #{p_poisson(2, k).round(3)} = #{(k * (k - 1) * rho_homo(0.2, k) * p_poisson(2, k)).round(3)}"
end

puts "Sum: #{cascade(0.2, 2).round(3)}"

puts ""
puts "First iterations for z = 8 and phi=0.2"

7.times do |k|
  puts "#{k} * #{k-1} * #{rho_homo(0.2, k)} * #{p_poisson(8, k).round(3)} = #{(k * (k - 1) * rho_homo(0.2, k) * p_poisson(8, k)).round(3)}"
end

puts "Sum: #{cascade(0.2, 8).round(3)}"
