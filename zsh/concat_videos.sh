#! /bin/sh

# Requirements
# - ffmpeg

set -e

create_input_list() {
  # 1 - folder path
  # 2 - list text file
  input_dir=${1}
  output_filename=${2:-list.txt}

  if [ ! -d $input_dir ]; then
    echo "Error: $input_dir is not a directory."
    exit 1
  fi

  if [ -f $output_filename ]; then
    rm $output_filename
  fi

  for video in $(ls $input_dir/*.mp4); do
    echo "file '$PWD/$video'" >> $output_filename
  done
}


concat_videos_from_list() {
  # 1 - filename of input list
  # 2 - output file name
  input_file_list=${1}
  output_filename=${2}

  if [ ! -f $input_file_list ]; then
    echo "Error: $input_file_list is not a file."
    exit 1
  fi

  echo $1 $2 $3
  ffmpeg -f concat -safe 0 -i $input_file_list -c copy $output_filename
}


concat_videos() {
  # 1 - folder with videos
  # 2 - output file name
  input_dir=${1}
  output_video=${2:-concat.mp4}

  create_input_list $input_dir $input_dir/list.txt
  concat_videos_from_list $input_dir/list.txt $output_video
  rm $input_dir/list.txt
}


concat_videos $1 $2
