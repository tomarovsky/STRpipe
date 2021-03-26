rule repeatmasker:
    input:
        fa = GENOME_PATH / "{genome}.fasta"
    output:
        out = "%s/{genome}.out" % repeatmasker_dir,
        tbl = "%s/{genome}.tbl" % repeatmasker_dir,
        masked = "%s/{genome}.masked" % repeatmasker_dir,
        catgz = "%s/{genome}.cat.gz" % repeatmasker_dir
    threads:
        N_threads
    shell:
        "RepeatMasker -pa {threads} -species {repeatmasker_base} {input.fa}; "
        "mv {genome}.out {output.out}; "
        "mv {genome}.tbl {output.tbl}; "
        "mv {genome}.masked {output.masked}; "
	    "mv {genome}.cat.gz {output.catgz}; "