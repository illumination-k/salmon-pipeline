# salmon pipeline

## downloading gff, genome.fasta and cds.fasta from marchantia.info

```bash
bash downloader.sh
```

## make gentrome.fa and decoy.txt for salmon index

```bash 
/workspace/generateDecoyTranscript.sh -b $(which bedtools) -m $(which mashmap) -a MpTak1v5.1_r1.gff -g MpTak1v5.1.fasta -t MpTak1v5.1_r1.cds.fasta -o decoy
```

## make salmon index

```bash
salmon index -t decoy/gentrome.fa -i ref --decoy decoy/decoys.txt
```

## quantify expression levels

```bash
/workspace/salmon_pipeline.sh /path/to/directory mode(single or pair) scaledMethods(scaledTPM or scaledLengthTPM) threads
```