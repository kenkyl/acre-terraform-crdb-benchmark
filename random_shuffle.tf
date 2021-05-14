resource "random_shuffle" "acre-aa-benchmark" {
  # Regions with 3 AZs (had to change the name to the short version to create the ACRE hostname)
  input = [
    "centralus",
    "eastus",
    "eastus2",
    "westus2"
  ]
  result_count = 2
}