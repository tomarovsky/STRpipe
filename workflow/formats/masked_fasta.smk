rule get_masked_fasta_gz:
    input:
        gff = rules.get_concat_sort_gff_gz.output,
        fa = GENOME_PATH / {genome}.fasta
    output:
        OUTPATH / "{genome}.repeatmasker.trf.windowmasker.fasta.gz"
    shell:
        "bedtools maskfasta -soft -bed {input.gff} -fi {input.fa} -fo {output}; "
        "gzip {output}; "
