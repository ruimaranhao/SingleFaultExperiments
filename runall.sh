

export D4J_HOME=/SFExps/D4J/
export GZOLTAR_JAR=/SFExps/scripts/com.gzoltar.lib-1.5.0-SNAPSHOT-jar-with-dependencies.jar

for i in `seq 1 26`; do
  echo $i
  ./gzoltar_diagnose.sh Chart $i OCHIAI Chart-$i-Ochiai
  ./gzoltar_diagnose.sh Chart $i IDEAL Chart-$i-Ideal
  ./gzoltar_diagnose.sh Chart $i TARANTULA Chart-$i-tarantula
  ./gzoltar_diagnose.sh Chart $i NAISH1 Chart-$i-naish1
done

for i in `seq 1 133`; do
  echo $i
  ./gzoltar_diagnose.sh Closure $i OCHIAI Closure-$i-Ochiai
  ./gzoltar_diagnose.sh Closure $i IDEAL Closure-$i-Ideal
  ./gzoltar_diagnose.sh Closure $i TARANTULA Closure-$i-tarantula
  ./gzoltar_diagnose.sh Closure $i NAISH1 Closure-$i-naish1
done

for i in `seq 1 65`; do
  echo $i
  ./gzoltar_diagnose.sh Lang $i OCHIAI Lang-$i-Ochiai
  ./gzoltar_diagnose.sh Lang $i IDEAL Lang-$i-Ideal
  ./gzoltar_diagnose.sh Lang $i TARANTULA Lang-$i-tarantula
  ./gzoltar_diagnose.sh Lang $i NAISH1 Lang-$i-naish1
done

for i in `seq 1 106`; do
  echo $i
  ./gzoltar_diagnose.sh Math $i OCHIAI Math-$i-Ochiai
  ./gzoltar_diagnose.sh Math $i IDEAL Math-$i-Ideal
  ./gzoltar_diagnose.sh Math $i TARANTULA Math-$i-tarantula
  ./gzoltar_diagnose.sh Math $i NAISH1 Math-$i-naish1
done

for i in `seq 1 27`; do
  echo $i
  ./gzoltar_diagnose.sh Time $i OCHIAI Time-$i-Ochiai
  ./gzoltar_diagnose.sh Time $i IDEAL Time-$i-Ideal
  ./gzoltar_diagnose.sh Time $i TARANTULA Time-$i-tarantula
  ./gzoltar_diagnose.sh Time $i NAISH1 Time-$i-naish1
done
