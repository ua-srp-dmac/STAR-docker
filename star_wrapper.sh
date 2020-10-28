#!/bin/bash

usage() {
    echo ""
    echo "Usage : sh $0 -g GENOME_DIR -f FASTQ_FILES -t NUM_THREADS -c READ_FILES_COMMAND"
    echo ""

cat <<'EOF'
  -f </path/to/fastq file>
  -a </path/to/reference genome>
EOF
    exit 0
}

while getopts "f:p:t:hg:r:o:" opt; do
  case ${opt} in
    f)
      if [ -z "$read_files" ]
      then
        read_files=$OPTARG
      else
        read_files=$read_files','$OPTARG
      fi
      ;;
    p)
      if [ -z "$paired_files" ]
      then
        paired_files=$OPTARG
      else
        paired_files=$paired_files','$OPTARG
      fi
      ;;
    t)
      num_threads=$OPTARG
      ;;
    g)
      genome_dir=$OPTARG
      ;;
    h)
      usage
      exit 1
      ;;    
    r)
      read_files_command=$OPTARG
      ;;
    o)
      sjdbOverhang=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "$read_files"
echo "$paired_files"

command="STAR --quantMode GeneCounts --genomeDir $genome_dir --sjdbOverhang $sjdbOverhang --readFilesIn $read_files"

if [ -n "$paired_files" ]
then
  command+=" $paired_files"
fi

if [ -n "$read_files_command" ]
then
  command+=" --readFilesCommand $read_files_command"
fi

if [ -n "$num_threads" ]
then
  command+=" --runThreadN $num_threads"
fi

echo "$command"

eval $command
