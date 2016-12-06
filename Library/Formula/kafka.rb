require 'formula'

class Kafka < Formula
  url 'http://sna-projects.com/kafka/downloads/kafka-0.6.zip'
  homepage 'http://incubator.apache.org/kafka/index.html'
  md5 'fa3a6ff42c480aed7c5a1b74a74fc642'

  def install
    bin.install Dir["bin/*"]
    mv "config", "kafka"
    etc.install Dir["kafka"]
    lib.install Dir["*.jar"]
    lib.install Dir["lib/*.jar"]
  end

  def patches
    # Updates classpath and config path in shell wrapper scripts
    DATA
  end
end

__END__
--- a/bin/kafka-run-class.sh	2011-05-23 14:21:00.000000000 -0400
+++ b/kafka-run-class.sh	2011-08-10 23:37:48.000000000 -0400
@@ -6,14 +6,7 @@
   exit 1
 fi
 
-base_dir=$(dirname $0)/..
-
-for file in $base_dir/*.jar;
-do
-  CLASSPATH=$CLASSPATH:$file
-done
-
-for file in $base_dir/lib/*.jar;
+for file in $(brew --prefix kafka)/lib/*.jar;
 do
   if [ ${file##*/} != "sbt-launch.jar" ]; then
     CLASSPATH=$CLASSPATH:$file
@@ -23,7 +16,7 @@
   KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false "
 fi
 if [ -z "$KAFKA_OPTS" ]; then
-  KAFKA_OPTS="-Xmx512M -server  -Dlog4j.configuration=file:$base_dir/config/log4j.properties"
+  KAFKA_OPTS="-Xmx512M -server  -Dlog4j.configuration=file:$(brew --prefix)/etc/kafka/log4j.properties"
 fi
 if [  $JMX_PORT ]; then
   KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT "

