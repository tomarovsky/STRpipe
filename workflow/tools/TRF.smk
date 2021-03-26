rule trf:
    input:
        fa = GENOME_PATH / "{genome}.fasta"
    output:
        dat = "{trf_dir}/{genome}" + "." + ".".join(config["TRF_parameters"].split()) + ".dat"
    params:
        TRF_parameters = config["TRF_parameters"],
        tmp_out = "{genome}" + "." + ".".join(config["TRF_parameters"].split()) + ".dat"
    shell:
        "trf {input.fa} {params} -d -h; " # || true;
        "mv {params.tmp_out} {output.dat}; "