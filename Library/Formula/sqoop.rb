class Sqoop < Formula
  desc "Transfer bulk data between Hadoop and structured datastores"
  homepage "https://sqoop.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=sqoop/1.4.6/sqoop-1.4.6.bin__hadoop-2.0.4-alpha.tar.gz"
  version "1.4.6"
  sha256 "d582e7968c24ff040365ec49764531cb76dfa22c38add5f57a16a57e70d5d496"

  depends_on "hadoop"
  depends_on "hbase"
  depends_on "hive"
  depends_on "zookeeper"
  depends_on "coreutils"

  def spoop_envs
    <<-EOS.undent
      export HADOOP_HOME="#{HOMEBREW_PREFIX}"
      export HBASE_HOME="#{HOMEBREW_PREFIX}"
      export HIVE_HOME="#{HOMEBREW_PREFIX}"
      export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def install
    libexec.install %w[bin conf lib]
    libexec.install Dir["*.jar"]

    # use coreutils' readlink instead of the OS X one to get the '-f' option
    scripts = %w[
      sqoop sqoop-codegen sqoop-create-hive-table sqoop-eval
      sqoop-export sqoop-help sqoop-import sqoop-import-all-tables
      sqoop-import-mainframe sqoop-job sqoop-list-databases sqoop-list-tables
      sqoop-merge sqoop-metastore sqoop-version]
    inreplace scripts.map { |s| "#{libexec}/bin/#{s}" }, /\breadlink\b/, "greadlink"

    bin.write_exec_script Dir["#{libexec}/bin/*"]

    # Install a sqoop-env.sh file
    envs = libexec/"conf/sqoop-env.sh"
    envs.write(spoop_envs) unless envs.exist?
  end

  def caveats; <<-EOS.undent
    Hadoop, Hive, HBase and ZooKeeper must be installed and configured
    for Sqoop to work.
    EOS
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    assert_match(/Sqoop #{version}/, shell_output("#{bin}/sqoop-version"))
  end
end
