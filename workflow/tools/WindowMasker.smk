rule windowmasker:
    input:
        fa = GENOME_PATH / "{genome}.fasta"
    output:
        counts = windowmasker_dir / "{fasta_prefix}.counts",
        interval = windowmasker_dir / "{fasta_prefix}.interval"
    shell:
        "windowmasker -in {input.fa} -infmt fasta -mk_counts -parse_seqids -out {output.counts}; "
        "windowmasker -in {input.fa} -infmt fasta -ustat {output.counts} -outfmt interval -parse_seqids -out {output.interval}; "
