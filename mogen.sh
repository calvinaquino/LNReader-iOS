#!/bin/sh

PROJECT_NAME="Bakareader EX"
MODELS="Bakareader_EX"

for MODEL in $MODELS; do
    mogenerator -m "$PROJECT_NAME/$PROJECT_NAME/$MODEL.xcdatamodeld/$MODEL.xcdatamodel" --machine-dir $PROJECT_NAME/Model/Entities --human-dir $PROJECT_NAME/Model --template-var arc=true
done
