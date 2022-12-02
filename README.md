# Compute and verify md5sums in gz-compressed files

## Installation

```bash
# Clone this repository where it fits
# e.g., cd ~/repositories
git clone cpauvert/md5sum-in-gz
# Go to a directory that is indexed by your PATH
# e.g., cd ~/local/
ln -s ~/repositories/compute-md5-gz.sh
ln -s ~/repositories/verify-md5-gz.sh
# Make the script executable
chmod +x compute-md5-gz.sh
chmod +x verify-md5-gz.sh
```

## Usage

### Compute md5sum

#### Help

Run the scripts without arguments to print the help page.

```bash
compute-md5-gz.sh
```

```
Compute md5sum for files within archives

Usage: ./compute-md5-gz.sh ARCHIVE(S) > MD5SUMS

Arguments:
    ARCHIVE(S)     Archive file(s) list
Output:
    Two-column file with md5sum and filename
```

#### Example

In a directory with `foo.fasta.gz` and `bar.fasta.gz`, the following command:


```bash
compute-md5-gz.sh *.gz > MD5SUMS
```

With MD5SUMS as:

```
b801bda37276a17954fba02e5815c568  foo.fasta
8dc71917509fb4f7af25dc2fcf628900  bar.fasta
```

### Verify md5sum

#### Help

Run the scripts without arguments to print the help page.

```bash
verify-md5-gz.sh
```

```
Verify md5sum for files within archives.

Usage: The working directory should be *same* as the ARCHIVE(S)
      ./verify-md5-gz.sh MD5SUMS ARCHIVE(S)

Arguments:
    MD5SUMS        Two-column file with md5sum and filename
    ARCHIVE(S)     Archive file(s) list
Output:
    No output if the md5sums are identical.
    A csv file with the expected filename and md5sum
      and the measured filename and md5sum if md5sums differ.
```

#### Example 

In a directory with foo.fasta.gz and bar.fasta.gz, and a MD5SUMS file (produced from `compute-md5-gz.sh`) the following command:

```bash
verify-md5-gz.sh MD5SUMS *.gz
```

*If the files are conform*, the command will not output anything (just like `diff`). 

*If the files are **not** conform*, the command will will produce the following csv table:

```
expected_file,expected_md5sum,tested_file,tested_md5sum
foo.fasta,f662e3a3710d94a841a41726e010ef95,foo.fasta,b9ffcc8fc80d07433a5a28b565d28324
```
