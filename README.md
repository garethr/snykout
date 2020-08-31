# SnykOut

![Test](https://github.com/garethr/snykout/workflows/Test/badge.svg)

A command line tool which provides an alternative user interface to `snyk test` output.


## Example

`snykout` takes the JSON output from `snyk test` and provides a number of alternative presentations of the information.
The basic output consists of a table of vulnerabilities.

```console
$ snyk container test garethr/snykit --json | snykout

+--------------------------------------------------------------------------------------------------------------------------------+
| Found 82 unique vulnerabiliies for garethr/snykit                                                                              |
+----------------------+------------+----------------+-------------------------------------------------+------------+------------+
| Package              | Severity   | ID             | Issue                                           | Installed  | Fixed in   |
+----------------------+------------+----------------+-------------------------------------------------+------------+------------+
| sqlite3/libsqlite3-0 | HIGH       | CVE-2020-9794  | Out-of-bounds Read                              | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | MEDIUM     | CVE-2019-16168 | Divide By Zero                                  | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | MEDIUM     | CVE-2020-13631 | CVE-2020-13631                                  | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | MEDIUM     | CVE-2020-13434 | Integer Overflow or Wraparound                  | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | MEDIUM     | CVE-2019-20218 | Improper Handling of Exceptional Conditions     | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | MEDIUM     | CVE-2020-11655 | Improper Input Validation                       | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2020-13871 | Use After Free                                  | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2020-13632 | NULL Pointer Dereference                        | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2020-13630 | Use After Free                                  | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2020-13435 | NULL Pointer Dereference                        | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2020-11656 | Use After Free                                  | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2020-9327  | NULL Pointer Dereference                        | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2019-19959 | CVE-2019-19959                                  | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2019-19923 | NULL Pointer Dereference                        | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2019-19924 | Improper Handling of Exceptional Conditions     | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2019-19925 | Unrestricted Upload of File with Dangerous Type | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2019-19603 | CVE-2019-19603                                  | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2019-19645 | Uncontrolled Recursion                          | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2019-19244 | Improper Input Validation                       | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2019-19242 | NULL Pointer Dereference                        | 3.27.2-3   |            |
| sqlite3/libsqlite3-0 | LOW        | CVE-2020-15358 | Out-of-bounds Write                             | 3.27.2-3   |            |
+----------------------+------------+----------------+-------------------------------------------------+------------+------------+

+------------------------------------------------------------------------------------------------------------------------------------------------------+
| Base image vulnerabilities from ruby:2.7.0-slim                                                                                                      |
+------------------------+------------+------------------+-------------------------------------------------------+------------------+------------------+
| Package                | Severity   | ID               | Issue                                                 | Installed        | Fixed in         |
+------------------------+------------+------------------+-------------------------------------------------------+------------------+------------------+
| perl/perl-base         | HIGH       | CVE-2020-10878   | Integer Overflow or Wraparound                        | 5.28.1-6         | 5.28.1-6+deb10u1 |
| apt/libapt-pkg5.0      | MEDIUM     | CVE-2020-3810    | Improper Input Validation                             | 1.8.2            | 1.8.2.1          |
| gcc-8/libstdc++6       | MEDIUM     | CVE-2018-12886   | Information Exposure                                  | 8.3.0-6          |                  |
| glibc/libc-bin         | MEDIUM     | CVE-2020-1752    | Use After Free                                        | 2.28-10          |                  |
| glibc/libc-bin         | MEDIUM     | CVE-2020-1751    | Out-of-bounds Write                                   | 2.28-10          |                  |
| libidn2/libidn2-0      | MEDIUM     | CVE-2019-12290   | Improper Input Validation                             | 2.0.5-1+deb10u1  |                  |
| pcre3/libpcre3         | MEDIUM     | CVE-2020-14155   | Integer Overflow or Wraparound                        | 2:8.39-12        |                  |
| perl/perl-base         | MEDIUM     | CVE-2020-10543   | Out-of-bounds Write                                   | 5.28.1-6         | 5.28.1-6+deb10u1 |
| perl/perl-base         | MEDIUM     | CVE-2020-12723   | Buffer Overflow                                       | 5.28.1-6         | 5.28.1-6+deb10u1 |
| apt/libapt-pkg5.0      | LOW        | CVE-2011-3374    | Improper Verification of Cryptographic Signature      | 1.8.2            |                  |
| bash                   | LOW        | CVE-2019-18276   | CVE-2019-18276                                        | 5.0-4            |                  |
| coreutils              | LOW        | CVE-2016-2781    | Improper Input Validation                             | 8.30-3           |                  |
| coreutils              | LOW        | CVE-2017-18018   | Race Condition                                        | 8.30-3           |                  |
| gcc-8/libstdc++6       | LOW        | CVE-2019-15847   | Insufficient Entropy                                  | 8.3.0-6          |                  |
| glibc/libc-bin         | LOW        | CVE-2010-4052    | Resource Management Errors                            | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2019-19126   | Information Exposure                                  | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2020-6096    | Integer Underflow                                     | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2019-9192    | Uncontrolled Recursion                                | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2018-20796   | Resource Management Errors                            | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2020-10029   | Out-of-Bounds                                         | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2016-10228   | Improper Input Validation                             | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2019-1010024 | Information Exposure                                  | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2019-1010025 | Use of Insufficiently Random Values                   | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2019-1010023 | Access Restriction Bypass                             | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2019-1010022 | Out-of-Bounds                                         | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2010-4051    | CVE-2010-4051                                         | 2.28-10          |                  |
| glibc/libc-bin         | LOW        | CVE-2010-4756    | Resource Management Errors                            | 2.28-10          |                  |
| gnupg2/gpgv            | LOW        | CVE-2019-14855   | Use of a Broken or Risky Cryptographic Algorithm      | 2.2.12-1+deb10u1 |                  |
| gnutls28/libgnutls30   | LOW        | CVE-2011-3389    | Improper Input Validation                             | 3.6.7-4+deb10u2  |                  |
| gnutls28/libgnutls30   | LOW        | CVE-2020-11501   | Use of a Broken or Risky Cryptographic Algorithm      | 3.6.7-4+deb10u2  | 3.6.7-4+deb10u3  |
| gnutls28/libgnutls30   | LOW        | CVE-2020-13777   | Use of a Broken or Risky Cryptographic Algorithm      | 3.6.7-4+deb10u2  | 3.6.7-4+deb10u4  |
| libgcrypt20            | LOW        | CVE-2018-6829    | Information Exposure                                  | 1.8.4-5          |                  |
| libgcrypt20            | LOW        | CVE-2019-12904   | Cryptographic Issues                                  | 1.8.4-5          |                  |
| libgcrypt20            | LOW        | CVE-2019-13627   | Race Condition                                        | 1.8.4-5          |                  |
| libseccomp/libseccomp2 | LOW        | CVE-2019-9893    | Access Restriction Bypass                             | 2.3.3-4          |                  |
| libtasn1-6             | LOW        | CVE-2018-1000654 | Resource Management Errors                            | 4.13-3           |                  |
| lz4/liblz4-1           | LOW        | CVE-2019-17543   | Buffer Overflow                                       | 1.8.3-1          |                  |
| openssl/libssl1.1      | LOW        | CVE-2010-0928    | Cryptographic Issues                                  | 1.1.1d-0+deb10u2 |                  |
| openssl/libssl1.1      | LOW        | CVE-2019-1551    | Information Exposure                                  | 1.1.1d-0+deb10u2 |                  |
| openssl/libssl1.1      | LOW        | CVE-2020-1967    | NULL Pointer Dereference                              | 1.1.1d-0+deb10u2 | 1.1.1d-0+deb10u3 |
| openssl/libssl1.1      | LOW        | CVE-2007-6755    | Cryptographic Issues                                  | 1.1.1d-0+deb10u2 |                  |
| pcre3/libpcre3         | LOW        | CVE-2017-7245    | Out-of-Bounds                                         | 2:8.39-12        |                  |
| pcre3/libpcre3         | LOW        | CVE-2017-7246    | Out-of-Bounds                                         | 2:8.39-12        |                  |
| pcre3/libpcre3         | LOW        | CVE-2017-11164   | Resource Management Errors                            | 2:8.39-12        |                  |
| pcre3/libpcre3         | LOW        | CVE-2017-16231   | Out-of-Bounds                                         | 2:8.39-12        |                  |
| pcre3/libpcre3         | LOW        | CVE-2019-20838   | Out-of-bounds Read                                    | 2:8.39-12        |                  |
| perl/perl-base         | LOW        | CVE-2011-4116    | Link Following                                        | 5.28.1-6         |                  |
| shadow/passwd          | LOW        | CVE-2019-19882   | Incorrect Permission Assignment for Critical Resource | 1:4.5-1.1        |                  |
| shadow/passwd          | LOW        | CVE-2007-5686    | Access Restriction Bypass                             | 1:4.5-1.1        |                  |
| shadow/passwd          | LOW        | CVE-2018-7169    | Security Features                                     | 1:4.5-1.1        |                  |
| shadow/passwd          | LOW        | CVE-2013-4235    | Time-of-check Time-of-use (TOCTOU)                    | 1:4.5-1.1        |                  |
| systemd/libsystemd0    | LOW        | CVE-2013-4392    | Access Restriction Bypass                             | 241-7~deb10u3    |                  |
| systemd/libsystemd0    | LOW        | CVE-2019-9619    | CVE-2019-9619                                         | 241-7~deb10u3    |                  |
| systemd/libsystemd0    | LOW        | CVE-2019-3844    | Access Restriction Bypass                             | 241-7~deb10u3    |                  |
| systemd/libsystemd0    | LOW        | CVE-2019-3843    | Access Restriction Bypass                             | 241-7~deb10u3    |                  |
| systemd/libsystemd0    | LOW        | CVE-2018-20839   | Information Exposure                                  | 241-7~deb10u3    |                  |
| systemd/libsystemd0    | LOW        | CVE-2019-20386   | Missing Release of Resource after Effective Lifetime  | 241-7~deb10u3    |                  |
| systemd/libsystemd0    | LOW        | CVE-2020-1712    | Use After Free                                        | 241-7~deb10u3    | 241-7~deb10u4    |
| systemd/libsystemd0    | LOW        | CVE-2020-13776   | Improper Input Validation                             | 241-7~deb10u3    |                  |
| tar                    | LOW        | CVE-2005-2541    | CVE-2005-2541                                         | 1.30+dfsg-6      |                  |
| tar                    | LOW        | CVE-2019-9923    | NULL Pointer Dereference                              | 1.30+dfsg-6      |                  |
+------------------------+------------+------------------+-------------------------------------------------------+------------------+------------------+
```

As well as the standard table output, `snykout` also supports:

* `--wide` which will show additional information about CVSS and CWE
* `--json` for a standardized JSON output suitable for further processing
* `--markdown` which will output tables as Markdown which can be copied into documentation
* As well as taking input on STDIN, `snykout` can also be pointed directly at a file, eg, `snykout fixtures/example.json`


## Open Policy Agent

`snykout` is also designed to work well with Open Policy Agent. This allows for writing arbitrary powerful policies against the resulting set of vulnerabilities. Take the following example which defines policies to catch cryptography issues.

```rego
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
```

You can use [Conftest](https://www.conftest.dev/) to run the policies.

```console
$ conftest test fixtures/snykout.json
WARN - fixtures/snykout.json - Cryptography issue (CWE-327). package: gnupg2/gpgv severity: low
WARN - fixtures/snykout.json - Cryptography issue (CWE-327). package: gnutls28/libgnutls30 severity: low
FAIL - fixtures/snykout.json - High severity issue found. package: perl/perl-base issue: Integer Overflow or Wraparound
FAIL - fixtures/snykout.json - High severity issue found. package: sqlite3/libsqlite3-0 issue: Out-of-bounds Read
FAIL - fixtures/snykout.json - High severity issue found. package: sqlite3 issue: Out-of-bounds Read

5 tests, 0 passed, 2 warnings, 3 failures, 0 exceptions
```

You can do everything in one line as well if you prefer.

```console
$ snyk container test garethr/snykit --json | snykout - --json | conftest test -
```

## Usage

You can see usage instructions for `snykout` from the inline help:

```console
$ snykout
  snykout - Show vulnerability information from Snyk test output

  Usage:
    snykout [flags] [arguments]

  Commands:
    help [command]  Help about any command.

  Flags:
    -h, --help         Help for this command.
        --json         Output results as JSON
        --markdown     Output results as Markdown
    -o, --output FILE  Output results as JSON
        --pretty       Make JSON results more human readable
        --wide         Output additional information in the table
        --yaml         Output results as YAML
```


## Installation

Precompiled executables are available Linux and macOS environments. These are available from [Releases](https://github.com/garethr/snykout/releases). You can grab those quickly with `wget` like so for Linux:

```console
wget -o snykout https://github.com/garethr/snykout/releases/download/v0.1.0/snykout_v0.1.0_linux-amd64
chmod +x snykout
```

And for macOS:

```console
wget -o snykout https://github.com/garethr/snykout/releases/download/v0.1.0/snykout_v0.1.0_darwin-amd64
chmod +x snykout
```

## Known issues

`snykout` is experimental, and will definiitely have bugs at this stage. In particular anything that outputs multiple results is not yet handled, for instance `--all-projects`.
