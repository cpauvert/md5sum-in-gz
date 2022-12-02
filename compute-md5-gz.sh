#!/usr/bin/env bash
# Tips from https://gist.github.com/andremueller/878a54dfb943575b299f22601d27f891#file-bash_template-sh

# Help/Usage message
function usage() {
    cat <<EOF
Compute md5sum for files within archives

Usage: $0 ARCHIVE(S) > MD5SUMS

Arguments:
    ARCHIVE(S)     Archive file(s) list
Output:
    Two-column file with md5sum and filename

Example:
    In a directory with foo.fasta.gz and bar.fasta.gz,
    the following command:

    $0 *.gz > MD5SUMS

    With MD5SUMS as:

    b801bda37276a17954fba02e5815c568  foo.fasta
    8dc71917509fb4f7af25dc2fcf628900  bar.fasta
EOF
}

# parse arguments
args=()
if [[ $# -eq 0 ]]; then
    usage
    exit 0
else
    ARCHIVE=("${@}")
fi

for element in "${ARCHIVE[@]}"; do
    zcat ${element}|md5sum |sed -e "s/-/$(basename ${element})/" -e "s/.gz$//"
done
