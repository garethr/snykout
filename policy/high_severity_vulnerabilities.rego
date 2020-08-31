package main

deny[msg] {
  issue = input.vulnerabilities[index]
  issue.severity = "high"

  msg = sprintf("package: %v issue: %v", [issue.name, issue.title])
}
