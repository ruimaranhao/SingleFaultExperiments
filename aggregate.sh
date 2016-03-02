touch all.csv

for csv in $(find . -type f -name "scores.csv"); do
  echo $csv
  [[ -z $header ]] && header="first row" && head -n 1 "$csv" >> all.csv
  tail -n +2 "$csv" >> all.csv
done
