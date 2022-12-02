#!/usr/bin/env bash
# Tips from https://gist.github.com/andremueller/878a54dfb943575b299f22601d27f891#file-bash_template-sh

# Help/Usage message
function usage() {
    cat <<EOF
Verify md5sum for files within archives.

Usage: The working directory should be *same* as the ARCHIVE(S)
      $0 MD5SUMS ARCHIVE(S)

Arguments:
    MD5SUMS        Two-column file with md5sum and filename
    ARCHIVE(S)     Archive file(s) list
Output:
    No output if the md5sums are identical.
    A csv file with the expected filename and md5sum
      and the measured filename and md5sum if md5sums differ.

Example:
    In a directory with foo.fasta.gz and bar.fasta.gz, and
    a MD5SUMS file (produced from compute-md5-gz.sh)
    the following command:

    $0 MD5SUMS *.gz

    will produce the following csv table if foo.fasta is corrupted:
    expected_file,expected_md5sum,tested_file,tested_md5sum
    foo.genome.fa,f662e3a3710d94a841a41726e010ef95,foo.genome.fa,b9ffcc8fc80d07433a5a28b565d28324
EOF
}

# parse arguments
args=()
if [[ $# -eq 0 ]]; then
    usage
    exit 0
else
    MD5SUMS="${1}"
    shift
    ARCHIVE=("${@}")
fi

# Compute the MD5SUMS of the current archives
TMP_MD5SUM=$(mktemp)
for element in "${ARCHIVE[@]}"; do
    zcat ${element}|md5sum |sed -e "s/-/$(basename ${element})/" -e "s/.gz$//" >> ${TMP_MD5SUM}
done

# Compare the two checksums
diff -y "${MD5SUMS}" "${TMP_MD5SUM}" | grep '|' | awk '{OFS=","; print "expected_file","expected_md5sum","tested_file","tested_md5sum"}{print $2,$1,$5,$4}'

