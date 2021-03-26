datfile = {fasta_prefix} + "." + ".".join(TRF_parameters.split()) + ".dat"

rule trf:
    input:
        fa = {fasta_prefix}.fasta
    output:
        dat = "{trf_dir}/{fasta_prefix}" + "." + ".".join(TRF_parameters.split()) + ".dat"
    params:
        TRF_parameters
    shell:
        "trf {input.fa} {params} -d -h || true; "
        "mv {datfile} {output.dat}; "