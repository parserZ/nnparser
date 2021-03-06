#!/bin/bash

cd /users2/jguo/work/parser/clnndep

if [ $# -ne 2 ]; then
    echo "Usage: ./train.sh [lang] [oracle|0/1]"
    echo "Option: oracle=0 (arc-standard), 1 (nivre09)"
    exit -1
fi

# lang=${lang}
lang=$1
oracle=$2
corpus=udt/multi-source/$lang/
models=mono-models-swap/  # non-projective

# f_train=$corpus/multi-train.conll
# f_train=$corpus/multi-train-proj-edit.conll
f_train=$corpus/$lang-universal-train.conll
f_dev=$corpus/$lang-universal-dev.conll

if [ "$oracle" = "1" ]; then
    echo "Train Non-Projective(Nivre09)"
    model_dir=$models/$lang.model.delex.nivre09.vanilla
    f_conf=conf/multi/delex-dv-swap.cfg
else
    echo "Train Projective(ArcStandard)"
    model_dir=$models/$lang.model.delex.arcstd
    f_conf=conf/multi/delex-dv.cfg
fi

if [ ! -d $model_dir ]; then
    mkdir $model_dir
fi
f_model=$model_dir/model

echo "./bin/clnndep -train $f_train -model $f_model -cfg $f_conf"
./bin/clnndep -train $f_train \
              -model $f_model \
              -dev $f_dev \
              -cfg $f_conf

