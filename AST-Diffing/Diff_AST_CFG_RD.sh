#!/bin/bash

input="Schwarz"
nemo=/home/kotname/Documents/Diplom/Code/nemo/nemo
ex_nemo=/home/kotname/Documents/Diplom/Code/ex_nemo
jdime=/home/kotname/Documents/Diplom/Code/cpec-doop-and-jdime-experiments/jdime_application/jdime


# create new JDIME-CSV file from Jdime-input sources
cd $jdime/build/install/JDime/bin

#./JDime --mode structured $jdime/testres/ASTBBTests/$input.java  
# currently CSV is only produced with Log-level fine which dumps a lot of infos -> pipe them away
./JDime --mode structured $jdime/testres/ASTBBTests/{left,right}/$input.java -p --log fine >/dev/null 2>&1

# move CSV file to NEMO
mkdir -p $ex_nemo/AST-Diffing/data/AST/$input

cp TargetAST.csv $ex_nemo/AST-Diffing/data/AST/$input/TargetAST.csv

mkdir -p $ex_nemo/AST-Diffing/data/CFG/$input

# execute ControlFlowGraph Analysis 
cd $nemo

cargo run $ex_nemo/AST-Diffing/Analyses/CFG/CFG_split_AST.rls -I $ex_nemo/AST-Diffing/data/AST/$input -D $ex_nemo/AST-Diffing/data/CFG/$input --save-results --overwrite-results

# execute Reaching Definitions

mkdir -p $ex_nemo/AST-Diffing/data/ReDef/$input

sleep 1


cargo run $ex_nemo/AST-Diffing/Analyses/ReDef/ReDef_sides.rls -I $ex_nemo/AST-Diffing/data/CFG/$input/ -D $ex_nemo/AST-Diffing/data/ReDef/$input/ --save-results --overwrite-results
