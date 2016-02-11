

export D4J_HOME=/SFExps/D4J/
export GZOLTAR_JAR=/SFExps/scripts/com.gzoltar.lib-1.5.0-SNAPSHOT-jar-with-dependencies.jar

for i in `seq 1 26`; do
  echo $i
  ./gzoltar_diagnose.sh Chart $i OCHIAI Chart-$i-Ochiai
  ./gzoltar_diagnose.sh Chart $i IDEAL Chart-$i-Ideal
  ./gzoltar_diagnose.sh Chart $i TARANTULA Chart-$i-tarantula
  ./gzoltar_diagnose.sh Chart $i NAISH1 Chart-$i-naish1
done
