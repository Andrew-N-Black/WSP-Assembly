##BLOBTOOLS2 to filter out contaminants
#Two different installs were required (see install section below) in order to create a blobdir and assign taxa (cluster) 
#and to view the results on a web browser (local). 

#After creating a conda env, run BLOBTOOLS on the cluster as a job:

#!/bin/bash  
#SBATCH --job-name=blob_polished  
#SBATCH -A fnrdewoody  
#SBATCH -t 14-00:00:00  
#SBATCH -n 60  
  
cd $SLURM_SUBMIT_DIR  
  
module load bioinfo  
module load blast/2.10.0+  
  
#Load use.own module first   
module load use.own  
   
#Then load blobtools environment  
module load conda-env/blobtools-py3.7.0   
   
#Confirm that it loaded  
module list  
  
#Create a new BlobDir:  
~/blobtoolkit/blobtools2/blobtools create \  
    --fasta  ./pacbio/raw/wp4.polished.purged.fasta \  
    --meta ./C.tularosa.yaml \  
    --taxid 77115 \  
    --taxdump ~/blobtoolkit/taxdump \  
    /scratch/halstead/b/blackan/pupfish/assembly/blobDir 

#Next, need to run BLAST / DIAMOND and add results to blobDir

#!/bin/bash  
#SBATCH --job-name=blob_polished  
#SBATCH -A fnrdewoody  
#SBATCH -t 14-00:00:00  
#SBATCH -n 50  
  
cd $SLURM_SUBMIT_DIR  
  
module load bioinfo  
module load blast/2.10.0+  
module load diamond  
  
#Load use.own module first   
module load use.own   
#Then load blobtools environment  
module load conda-env/blobtools-py3.7.0    
#Confirm that it loaded  
module list  
  
  
#Activate conda session!  
source activate blobtools  

blastn -db nt \  
      -query ./wp4.polished.purged.fasta \  
      -outfmt "6 qseqid staxids bitscore std" \  
      -max_target_seqs 10 \  
      -max_hsps 1 \  
      -evalue 1e-25 \  
      -num_threads 50 \  
      -out ./wp4.polished.purged.fasta.ncbi.blastn.out  
  
diamond blastx \  
       --query ./wp4.polished.purged.fasta \  
       --db /scratch/halstead/b/blackan/DB/uniprot/reference_proteomes.dmnd \  
       --outfmt 6 qseqid staxids bitscore qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore \  
      --sensitive \  
      --max-target-seqs 1 \  
       --evalue 1e-25 \  
       --threads 50 \  
       > wp4.polished.purged.diamond.blastx.out  
  
# Add blastn and blastx hits to blob  
~/blobtoolkit/blobtools2/blobtools add --hits ./wp4.polished.purged.fasta.ncbi.blastn.out --hits ./wp4.polished.purged.diamond.blastx.out --taxrule bestsumorder --taxdump ../../DB/taxdump /scratch/halstead/b/blackan/pupfish/assembly/blobDir/  

#Confirm that all of the output files, and error logs, are satisfactory and then download the entire blobdir to a local machine.
 
##BLOBTOOLS2 viewer
 
The BlobDir will now be downloaded from the cluster to a local computer to view in a webrowser. To view the BlobDir, you will need to have two terminal windows open on your local machine, each running a separate btk_env:

#Run the following command within conda env in the ‘viewer’ directory:  
conda activate btk_env
BTK_FILE_PATH=/Users/black_cgrb/DATASETS npm start  

#You should see the following displayed: 
#. . . 
#BlobToolKit RESTful API server started on http port: 8000  
  
#Note, the DATASETS directory has a subdirectory of "ASSEMBLY_NAME" and "FILES"  
#The ASSEMBLY_NAME had the jston files and the FILES directory had the blast/fasta file  
  
#In a seperate terminal run the following in the 'viewer' directory  
conda activate btk_env
npm run client  
#You should see the following displayed:  
#. . .
[./node_modules/css-loader/dist/runtime/api.js] 2.46 KiB {mini-css-extract-plugin} [built]  
ℹ ｢wdm｣: Compiled successfully.  
  
#Now open up a firefox browser at localhost to view:  
http://localhost:8080/view/all/  
Once the non-target sequences have been identified (by bestsumphylum) use the filter function implemented in blobtools:
~/blobtoolkit/blobtools2/blobtools filter --query-string 'bestsumorder_phylum--Keys=no-hit,Arthropoda,Chytridiomycota' --fasta ~/DATASETS/FILES/ASSEMBLY_NAME.fasta ~/DATASETS/ASSEMBLY_NAME  


