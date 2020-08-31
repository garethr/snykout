package main

deny[msg] {
  issue = input.vulnerabilities[index]
  issue.cwe[_] = "CWE-327"
  issue.severity = "high"

  msg = sprintf("High severity cryptography issue (CWE-327). package: %v", [issue.name])
}

warn[msg] {
  issue = input.vulnerabilities[index]
  issue.cwe[_] = "CWE-327"
  issue.severity != "high"

  msg = sprintf("Cryptography issue (CWE-327). package: %v severity: %v", [issue.name, issue.severity])
}
