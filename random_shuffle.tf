resource "random_shuffle" "acre-aa-benchmark" {
  # Regions with 3 AZs
  input = [
    "Central US",
    "East US",
    "East US 2",
    "West US 2"
  ]
  result_count = 2
}
