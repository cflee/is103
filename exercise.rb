def calculateBMI(weight, height)
  weight.to_f / height.to_f ** 2
end

def getBMIcategory(bmi)
  return "underweight" if bmi <= 18.5
  return "normal" if bmi <= 25
  return "overweight" if bmi <= 30
  "obese"
end

def run
  print "Enter mass in kg: "
  mass = gets.chomp.to_f
  print "Enter height in m: "
  height = gets.chomp.to_f

  bmi = calculateBMI(mass, height)

  puts "Your BMI is #{bmi}"
  puts "You are #{getBMIcategory(bmi)}"
end