import os
# configfile: "config.json"
# this should be the only path that you need to modify
GENOME_BASE_PATH = config["GENOME_BASE_PATH"] # == "./"
ANNO_BASE_PATH = config["ANNO_BASE_PATH"]

GENOME_FA = GENOME_BASE_PATH + config["GENOME_FA"]
GENOME_FA_PREFIX = os.path.splitext(config["GENOME_FA"])[0].split("/")[-1]
RM_BASE = config["RM_BASE"]
N_THREADS = config["N_THREADS"] # max threads value. run with '--cores'
TRF_PARAMETERS = config["TRF_PARAMETERS"]
CONCAT_SORT_GFF_GZ = ANNO_BASE_PATH + GENOME_FA_PREFIX + ".repeatmasker.trf.windowmasker.gff.gz"
MASKED_FA = ANNO_BASE_PATH + GENOME_FA_PREFIX + ".repeatmasker.trf.windowmasker.fasta"
MASKED_FA_GZ = MASKED_FA + ".gz"

# paths
TRF_DIR = ANNO_BASE_PATH + "TRF/"
RM_DIR = ANNO_BASE_PATH + "RepeatMasker/"
WM_DIR = ANNO_BASE_PATH + "WindowMasker/"

# trf
DAT_FILE = GENOME_FA + "." + ".".join(TRF_PARAMETERS.split()) + ".dat"
DAT_FILE_OUTPATH = TRF_DIR + DAT_FILE
DAT_GFF_FILE_PREFIX = (os.path.splitext(DAT_FILE_OUTPATH)[0])
DAT_GFF_FILE = DAT_GFF_FILE_PREFIX + ".gff.gz"
# repeatmasker
OUT_FILE =  GENOME_FA + ".out"
OUT_FILE_OUTPATH = RM_DIR + OUT_FILE
OUT_GFF_FILE_PREFIX = (os.path.splitext(OUT_FILE_OUTPATH)[0])
OUT_GFF_FILE = OUT_GFF_FILE_PREFIX + ".gff.gz"
TBL_FILE = GENOME_FA + ".tbl"
TBL_FILE_OUTPATH = RM_DIR + TBL_FILE
MASKED_FILE = GENOME_FA + ".masked"
MASKED_FILE_OUTPATH = RM_DIR + MASKED_FILE
CATGZ_FILE = GENOME_FA + ".cat.gz"
CATGZ_FILE_OUTPATH = RM_DIR + CATGZ_FILE
# windowmasker
COUNTS_FILE_OUTPATH = "{0}{1}.counts".format(WM_DIR, GENOME_FA_PREFIX)
INTERVAL_FILE_OUTPATH = "{0}{1}.interval".format(WM_DIR, GENOME_FA_PREFIX)
INTERVAL_GFF_FILE_PREFIX = (os.path.splitext(INTERVAL_FILE_OUTPATH)[0])
INTERVAL_GFF_FILE = INTERVAL_GFF_FILE_PREFIX + ".gff.gz"
 

# initialization
def create_files_and_directories():
    import os
    # Create directories
    os.makedirs(TRF_DIR, exist_ok=True)
    os.makedirs(WM_DIR, exist_ok=True)
    os.makedirs(RM_DIR, exist_ok=True)
    # Create files

create_files_and_directories()

rule all:
    input:
        MASKED_FA_GZ

rule trf:
    input:
        fa = GENOME_FA
    output:
        dat = DAT_FILE_OUTPATH
    params:
        TRF_PARAMETERS
    shell:
        "trf {input.fa} {params} -d -h || true; "
        "mv {DAT_FILE} {output.dat}; "

rule repeatmasker:
    input:
        fa = GENOME_FA
    output:
        out = OUT_FILE_OUTPATH,
        tbl = TBL_FILE_OUTPATH,
        masked = MASKED_FILE_OUTPATH,
        catgz = CATGZ_FILE_OUTPATH
    threads:
        N_THREADS
    shell:
        "/home/skliver/Soft/RepeatMasker/RepeatMasker -pa {threads} -species {RM_BASE} {input.fa}; "
        "mv {OUT_FILE} {output.out}; "
        "mv {TBL_FILE} {output.tbl}; "
        "mv {MASKED_FILE} {output.masked}; "
	"mv {CATGZ_FILE} {output.catgz}; "

rule windowmasker:
    input:
        fa = GENOME_FA
    output:
        counts = COUNTS_FILE_OUTPATH,
        interval = INTERVAL_FILE_OUTPATH
    shell:
        "windowmasker -in {input.fa} -infmt fasta -mk_counts -parse_seqids -out {output.counts}; "
        "windowmasker -in {input.fa} -infmt fasta -ustat {output.counts} -outfmt interval -parse_seqids -out {output.interval}; "

rule trf_dat_to_gff:
    input:
        DAT_FILE_OUTPATH
    output:
        DAT_GFF_FILE
    shell:
        "~/tools/Biocrutch/scripts/RepeatMasking/TRF.py -i {input} -o {DAT_GFF_FILE_PREFIX}; "


rule repeatmasker_out_to_gff:
    input:
        OUT_FILE_OUTPATH
    output:
        OUT_GFF_FILE
    shell:
        "~/tools/Biocrutch/scripts/RepeatMasking/RepeatMasker.py -i {input} -o {OUT_GFF_FILE_PREFIX}; "

rule windowmasker_interval_to_gff:
    input:
        INTERVAL_FILE_OUTPATH
    output:
        INTERVAL_GFF_FILE
    shell:
        "~/tools/Biocrutch/scripts/RepeatMasking/WindowMasker.py -i {input} -o {INTERVAL_GFF_FILE_PREFIX}; "

rule get_concat_sort_gff_gz:
    input:
        DAT_GFF_FILE,
        OUT_GFF_FILE,
        INTERVAL_GFF_FILE
    output:
        CONCAT_SORT_GFF_GZ
    shell:
        "zcat {input} | sort -k1,1 -k4,4n -k5,5n | gzip > {output}; "

rule get_masked_fasta_gz:
    input:
        gff = CONCAT_SORT_GFF_GZ,
        fa = GENOME_FA
    output:
        MASKED_FA_GZ
    shell:
        "bedtools maskfasta -soft -bed {input.gff} -fi {input.fa} -fo {MASKED_FA}; "
        "gzip {MASKED_FA}; "
