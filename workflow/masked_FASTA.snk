rule get_masked_fasta_gz:
    input:
        gff = rules.get_concat_sort_gff_gz.output,
        fa = {fasta_prefix}.fasta
    output:
        "{fasta_prefix}.repeatmasker.trf.windowmasker.fasta.gz"
    shell:
        "bedtools maskfasta -soft -bed {input.gff} -fi {input.fa} -fo {output}; "
        "gzip {output}; "
