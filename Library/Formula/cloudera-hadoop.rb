require 'formula'

class Java16Dependency < Requirement
  fatal true

  satisfy {
  java16_check =`/usr/libexec/java_home -v1.6 2>&1 | wc -l`.gsub("\n",'').strip
  java16_check == "1"
  }

  def message
    message = <<-EOS.undent
      cloudera-hadoop: needs Java 1.6 to build'
    EOS
  end
end

class ClouderaHadoop < Formula
  version "cdh4.4.0"
  homepage 'http://www.cloudera.com/content/cloudera/en/products-and-services/cdh.html'
  url 'http://archive.cloudera.com/cdh4/cdh/4/hadoop-2.0.0-cdh4.4.0.tar.gz'
  sha1 '4e7668d26ada2ae16649c6277356b95a0141d9dc'

  conflicts_with 'hadoop',
    :because => "cloudera-hadoop and hadoop install the same binaries."

  depends_on Java16Dependency => :build
  depends_on "protobuf" => :build
  depends_on "maven" => :build

  def patches
    # Fix configuration file to make it work with Homebrew folder names
    # Use protobuf 2.5.0 instead of 2.4.1 (deprecated)
    DATA
  end

  def setup_single_node_config
    inreplace Dir["etc/hadoop/core-site.xml"],
      /<configuration>/,"<configuration>\n
  <property>
    <name>fs.default.name</name>
    <value>hdfs://localhost:54310/</value>
  </property>\n"

    inreplace Dir["etc/hadoop/hdfs-site.xml"],
      /<configuration>/,"<configuration>\n
  <property>
    <name>dfs.name.dir</name>
    <value>/usr/local/var/lib/hdfs/name</value>
  </property>\n
  <property>
    <name>dfs.data.dir</name>
    <value>/usr/local/var/lib/hdfs/data</value>
  </property>\n
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>/usr/local/var/lib/hdfs/name</value>
  </property>\n"

    inreplace Dir["etc/hadoop/mapred-site.xml.template"],
      /<configuration>/,"<configuration>\n
  <property>
    <name>mapred.job.tracker</name>
    <value>localhost:8020</value>
  </property>\n
  <property>
    <name>mapreduce.framework.name</name>
    <value>classic</value>
  </property>\n"
  end

  def install
    setup_single_node_config
    mv "etc/hadoop/mapred-site.xml.template", "etc/hadoop/mapred-site.xml"
    cd "src"
    ENV['JAVA_HOME'] = `/usr/libexec/java_home -v1.6 2>&1`.gsub("\n",'')
    ENV['MAVEN_OPTS'] = "-Xmx512m"
    system "mvn", "package", "-Pdist",
           "-DskipTests",
           "-Dtar",
           "-Dmaven.javadoc.skip=true"
    mkdir "../binary"
    system "tar", "xzf", "hadoop-dist/target/hadoop-2.0.0-cdh4.4.0.tar.gz", "-C", "../binary"
    cd "../binary/hadoop-2.0.0-cdh4.4.0"
    cp_r "../../bin-mapreduce1", "."
    cp_r "../../etc/hadoop-mapreduce1", "etc/"
    %w[etc/hadoop/ etc/hadoop-mapreduce1].each do |dest|
      cp %w[core-site.xml hdfs-site.xml mapred-site.xml].map{ |x| "../../etc/hadoop/" + x.to_s },dest
    end
    cp_r "../../share/hadoop/mapreduce1", "share/hadoop/"

    inreplace Dir["etc/hadoop*/hadoop-env.sh"],
      /.*export JAVA_HOME=.*/,
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""

    libexec.install %w[bin bin-mapreduce1 etc sbin share]
    ln_s "#{libexec}/bin-mapreduce1", "#{libexec}/share/hadoop/mapreduce1/bin"
    ln_s "#{libexec}/etc/hadoop-mapreduce1", "#{libexec}/share/hadoop/mapreduce1/conf"
    libexec.install Dir["libexec/*"]
    bin.write_exec_script Dir["#{libexec}/{sb,b}in/*"]
    bin.write_exec_script Dir["#{libexec}/bin-mapreduce1/*mapred.sh"]

    # But don't make rcc visible, it conflicts with Qt
    (bin/'rcc').unlink

    inreplace "#{libexec}/hadoop-config.sh",'..',""
    fnames = Dir["#{libexec}/{sb,b}in/*"]
    fnames.each do |fname|
      inreplace fname, /DEFAULT_LIBEXEC_DIR=.*/,"DEFAULT_LIBEXEC_DIR=\"\$bin\"/.." unless fname.end_with? "httpfs.sh"
    end
  end

  def caveats; <<-EOS.undent
    In Hadoop's config file:
      #{libexec}/etc/hadoop*/hadoop-env.sh
    $JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home

    First of all, you need to format the Namenode with :
      hdfs namenode -format

    Then start the Namenode with :
      start-dfs.sh

    Finally, start the MapReduce processes (they are mutually exclusive)
     - start-yarn.sh for MRV2
     - start-mapred.sh for MRV1
    EOS
  end
end

__END__
--- a/bin-mapreduce1/hadoop-config.sh	2013-09-04 04:19:40.000000000 +0200
+++ b/bin-mapreduce1/hadoop-config.sh	2013-12-30 21:43:16.000000000 +0100
@@ -25,6 +25,9 @@
 script="$(basename -- "$this")"
 this="$bin/$script"
 
+HADOOP_HOME=$bin/../share/hadoop/mapreduce1
+HADOOP_CONF_DIR=$HADOOP_HOME/conf
+
 # the root of the Hadoop installation
 if [ -z "$HADOOP_HOME" ]; then
   export HADOOP_HOME=`dirname "$this"`/..
--- a/src/hadoop-project/pom.xml	2014-01-05 11:55:42.000000000 +0100
+++ b/src/hadoop-project/pom.xml	2014-01-05 11:43:57.000000000 +0100
@@ -595,7 +595,7 @@
       <dependency>
         <groupId>com.google.protobuf</groupId>
         <artifactId>protobuf-java</artifactId>
-        <version>2.4.0a</version>
+        <version>2.5.0</version>
       </dependency>
       <dependency>
         <groupId>commons-daemon</groupId>
