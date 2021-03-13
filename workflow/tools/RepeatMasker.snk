rule repeatmasker:
    input:
        fa = {fasta_prefix}.fasta
    output:
        out = "%s/{fasta_prefix}.out" % repeatmasker_dir,
        tbl = "%s/{fasta_prefix}.tbl" % repeatmasker_dir,
        masked = "%s/{fasta_prefix}.masked" % repeatmasker_dir,
        catgz = "%s/{fasta_prefix}.cat.gz" % repeatmasker_dir
    threads:
        N_threads
    shell:
        "RepeatMasker -pa {threads} -species {repeatmasker_base} {input.fa}; "
        "mv {fasta_prefix}.out {output.out}; "
        "mv {fasta_prefix}.tbl {output.tbl}; "
        "mv {fasta_prefix}.masked {output.masked}; "
	    "mv {fasta_prefix}.cat.gz {output.catgz}; "