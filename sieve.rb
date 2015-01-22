def sieve2(n)
  worksheet = Array(2..n)
  primes = []
  while worksheet.first <= sqrt(n)
    primes << worksheet.first
    worksheet.delete_if { |x| x % primes.last == 0 }
  end
  return primes + worksheet
end
