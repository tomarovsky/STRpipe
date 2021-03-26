rule trf_dat_to_gff:
    input:
        rules.trf.output.dat
    output:
        os.path.splitext(rules.trf.output.dat)[0] + ".gff.gz"
    params:
        tools=config["tools_path"]
    shell:
        "{params.tools}/Biocrutch/scripts/RepeatMasking/TRF.py -i {input} -o {output}; "


rule repeatmasker_out_to_gff:
    input:
        rules.repeatmasker.output.out
    output:
        os.path.splitext(rules.repeatmasker.output.out)[0] + ".gff.gz"
    params:
        tools=config["tools_path"]
    shell:
        "{params.tools}/Biocrutch/scripts/RepeatMasking/RepeatMasker.py -i {input} -o {output}; "

rule windowmasker_interval_to_gff:
    input:
        rules.windowmasker.output.interval
    output:
        os.path.splitext(rules.windowmasker.output.interval)[0] + ".gff.gz"
    params:
        tools=config["tools_path"]
    shell:
        "{params.tools}/Biocrutch/scripts/RepeatMasking/WindowMasker.py -i {input} -o {output}; "

rule get_concat_sort_gff_gz:
    input:
        rules.trf_dat_to_gff.output,
        rules.repeatmasker_out_to_gff.output,
        rules.windowmasker_interval_to_gff.output
    output:
        {fasta_prefix} + ".repeatmasker.trf.windowmasker.gff.gz"
    shell:
        "zcat {input} | sort -k1,1 -k4,4n -k5,5n | gzip > {output}; "
