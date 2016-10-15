require 'formula'

class SquirrelHive < Formula
  homepage 'http://www.squirrelsql.org/'
  url 'http://sourceforge.net/projects/squirrel-sql/files/1-stable/3.5.0-plainzip/squirrel-sql-3.5.0-standard.tar.gz'
  version '3.5.0'
  sha1 'da39a3ee5e6b4b0d3255bfef95601890afd80709'

  bottle do
    cellar :any
    sha1 "da39a3ee5e6b4b0d3255bfef95601890afd80709" => :yosemite
    sha1 "da39a3ee5e6b4b0d3255bfef95601890afd80709" => :mavericks
    sha1 "da39a3ee5e6b4b0d3255bfef95601890afd80709" => :mountain_lion
  end

  depends_on 'hadoop'
  depends_on 'hive'
  depends_on 'zookeeper'

  def install; <<-EOS.undent
    #!/bin/sh
    export HADOOP_HOME="#{HOMEBREW_PREFIX}"
    export HIVE_HOME="#{HOMEBREW_PREFIX}"

    _d="$(pwd)"
    gunzip squirrel-sql-3.5.0-standard.tar.gz
    tar xvf squirrel-sql-3.5.0-standard.tar
    cd squirrel-sql-3.5.0-standard

    cd lib
    wget https://wiki.intuit.com/download/attachments/208209645/hive-connector.tar.gz
    tar -xvf hive-connector.tar.gz
    export CLASSPATH=$CLASSPATH:$HADOOP_HOME/hadoop-*-core.jar:$HIVE_HOME/build/dist/lib/*.jar:squirrel-sql-3.5.0-standard/lib/*.jar
    cd "$_d"/squirrel-sql-3.5.0-standard

    # If kerberos file with domain_realm settings connect to remote hive, else need to have local hive server running
    #if !File.file?('/etc/krb5.conf')
    if [-f '/etc/krb5.conf'] then
        export JAVA_OPTS="-Djava.security.krb5.realm={REALM_NAME} -Djava.security.krb5.kdc={KDC_SERVER} -Dmapred.job.queue.name={QUEUE_NAME} -Djava.security.krb5.conf=/etc/krb5.conf"
       ./squirrel-sql.sh
    else
        $HIVE_HOME/bin/hive --service hiveserver -p 10000 -v
        ps cax | grep hiveserver
        if [ $? -eq 0 ]; then
            ./squirrel-sql.sh
    fi
    EOS
  end
 
 def caveats; <<-EOS.undent
    For Squirrel SQL hive connection to work:
    Hadoop, Hive, and ZooKeeper must be installed, configured correctly.Kerberos file must exists at client for remote hive connection.
    EOS
 end

end

