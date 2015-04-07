def calculate_payment(payment_rule, article)
  total = 0 # denominated in cents

  w = article.join
  total = payment_rule.map { |r| w.count(r[0]) * r[1] }.reduce(:+)

  return total / 100.0
end
