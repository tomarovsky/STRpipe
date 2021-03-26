import os
# configfile: "config.yaml"

GENOME_PREFIX = os.path.splitext(config["genome"])[0]

# paths
OUTPATH = config["out_path"]
GENOME_PATH = config["genome_path"]
trf_dir = "{0}/{1}".format(config["out_dir"], config["trf_dir"]).replace("//", "/")
repeatmasker_dir = "{0}/{1}".format(config["out_dir"], config["repeatmasker_dir"]).replace("//", "/")
windowmasker_dir = "{0}/{1}".format(config["out_dir"], config["windowmasker_dir"]).replace("//", "/")


# initialization
def create_files_and_directories():
    import os
    # Create directories
    os.makedirs(trf_dir, exist_ok=True)
    os.makedirs(repeatmasker_dir, exist_ok=True)
    os.makedirs(windowmasker_dir, exist_ok=True)
    # Create files

create_files_and_directories()

rule all:
    input:
        expand(OUTPATH / "{genome}.repeatmasker.trf.windowmasker.fasta.gz", genome=GENOME_PREFIX)
    shell: 
        "echo finished!"


include: "workflow/tools/TRF.snk"
include: "workflow/tools/RepeatMasker.snk"
include: "workflow/tools/WindowMasker.snk"
include: "workflow/formats/repeats_to_gff.snk"
include: "workflow/formats/masked_fasta.snk"