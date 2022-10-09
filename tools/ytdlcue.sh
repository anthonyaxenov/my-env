#!/bin/bash
# CUE-sheet generator for youtube-dl

# Usage:
# 0. Install 'jq' utility
# 1. Download any audio file with metadata from YouTube or Youtube Music, e.g.
#    $ youtube-dl \
#          --extract-audio \
#          --audio-format flac \
#          --audio-quality 0 \
#          --format bestaudio \
#          --write-info-json \
#          --output "/tmp/ytm/%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" \
#          https://www.youtube.com/watch?v=lVpDQnXz34M
#
#    If audio file is already downloaded earlier then just fetch only its metadata:
#    $ youtube-dl \
#          --write-info-json \
#          --skip-download \
#          --output "/tmp/ytm/%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" \
#          https://www.youtube.com/watch?v=lVpDQnXz34M
#
# 2. Audio and metadata files MUST be named exactly similar (except extenstion),
#    but it is not necessary to keep original names. Also they MUST be placed in
#    the same directory. Example:
#    /tmp/ytm/ABGT496.flac
#    /tmp/ytm/ABGT496.info.json
#
# 3. To create CUE file run ytdlcue with a path to audio file:
#    $ ytdlcue.sh /tmp/ytm/ABGT496.flac
#
#    A new file will be created in the same directory:
#    /tmp/ytm/ABGT496.cue

installed() {
    command -v "$1" >/dev/null 2>&1
}

! installed 'jq' && {
    echo "ERROR: you need to install jq!"
    exit 1
}

audio_path="$1" # path to audiofile
audio_file=`basename "$audio_path"` # audiofile name with extension
audio_name=${audio_file%.*} # audiofile name without extension
audio_ext=${audio_file##*.} # audiofile name extension
path="`dirname "$audio_path"`/$audio_name" # path to audiofile and its name without ext
json_path="$path.info.json" # path to json file with metadata created by youtube-dl
cue_path="$path.cue" # path to cue sheet to be generated

# echo -e "audio_path:\t$audio_path"
# echo -e "audio_file:\t$audio_file"
# echo -e "audio_name:\t$audio_name"
# echo -e "audio_ext:\t$audio_ext"
# echo -e "path:\t\t$path"
# echo -e "json_path:\t$json_path"
# echo -e "cue_path:\t$cue_path"

[ ! -f "$audio_path" ] && {
    echo "ERROR: File not found: $audio_path"
    exit 2
}
[ ! -f "$json_path" ] && {
    echo "ERROR: File not found: $json_path"
    exit 3
}

echo "PERFORMER `cat "$json_path" | jq -Mc '.channel'`"> $cue_path
echo "TITLE `cat "$json_path" | jq -Mc '.title'`" >> $cue_path
echo "FILE \"$audio_file\" ${audio_ext^^}" >> $cue_path

counter=1 # track counter (works only inside loop!)
cat "$json_path" | jq -Mc '.chapters[]' \
| while read chapter; do
    number=`printf %0.2d $counter` # pad current counter with zeros
    time=`echo "$chapter" | jq -Mc '.start_time'` # get initial start time in seconds
    time=`printf '%0.2d:%0.2d:00' $((time/60)) $((time%60))` # convert start time to minutes:seconds
    title=`echo "$chapter" | jq -Mc '.title' | sed -r "s#[\"]##g"` # get initial chapter title
    performer=`echo "$title" | cut -d "-" -f 1 | sed 's#^[[:space:]]*##g' | sed 's# *$##g'` # get and trim chapter's performer (before '-')
    title2=`echo "$title" | cut -d "-" -f 2 | sed 's#^[[:space:]]*##g' | sed 's# *$##g'` # get and trim chapter's title (after '-')
    #TODO: what if dash is not delimiter between performer and title?
    #TODO: take $title2 if $performer and (or?) $title2 are empty

    printf "%-2sTRACK $number AUDIO\n" >> $cue_path
    printf "%-4sPERFORMER \"$performer\"\n" >> $cue_path
    printf "%-4sTITLE \"$title2\"\n" >> $cue_path
    printf "%-4sINDEX 01 $time\n" >> $cue_path

    counter=`expr $counter + 1` # increase counter
done
echo "Done! Cue file:"
echo "$cue_path"
