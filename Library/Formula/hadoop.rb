require "formula"

class Hadoop < Formula
  homepage "http://hadoop.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=hadoop/common/hadoop-2.4.1/hadoop-2.4.1.tar.gz"
  sha1 "f4166392f1c9a4a3602477d85f51976d44d61c27"

  option "with-tests", "Run tests."

  build.with? "tests" and depends_on "maven", "findbugs", "protobuf", "cmake"

  resource "hadoop-2.4.1-src" do
    url "http://www.apache.org/dyn/closer.cgi?path=hadoop/common/hadoop-2.4.1/hadoop-2.4.1-src.tar.gz"
    sha1 "f4166392f1c9a4a3602477d85f51976d44d61c27"
  end

  def install
    if build.with? "tests"

      if !ENV["JAVA_HOME"] or !ENV["PROTOBUF_HOME"] or !ENV["FINDBUGS_HOME"]
        opoo "WARN! PATH:"
        opoo "JAVA_HOME: " + (ENV["JAVA_HOME"] ? ENV["JAVA_HOME"] : 'not set')
        opoo "HADOOP_PROTOC_PATH: " + (ENV["PROTOBUF_HOME"] ? ENV["PROTOBUF_HOME"] : 'not set')
        opoo "FINDBUGS_HOME: " + (ENV["FINDBUGS_HOME"] ? ENV["FINDBUGS_HOME"] : 'not set')
      end

      # set maven build project
      args = ["clean", "package", "-Pdist,docs,src"]
      (build.with? "test") or (args << )

      # set maven path
      mvn = "#{HOMEBREW_PREFIX}/bin/mvn"
      resource("hadoop-2.4.1-src").stage do
          system mvn, *args
          (buildpath+"dist").install Dir["hadoop-dist/*"]
      end
    else
      (buildpath+"dist").install Dir["*"]
    end

    cd "dist" do
      rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
      libexec.install %w[bin sbin libexec share etc]
      bin.write_exec_script Dir["#{libexec}/bin/*"]
      sbin.write_exec_script Dir["#{libexec}/sbin/*"]
      # But don't make rcc visible, it conflicts with Qt
      (bin/'rcc').unlink

      inreplace "#{libexec}/etc/hadoop/hadoop-env.sh",
        "export JAVA_HOME=${JAVA_HOME}",
        "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
      inreplace "#{libexec}/etc/hadoop/yarn-env.sh",
        "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
        "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
      inreplace "#{libexec}/etc/hadoop/mapred-env.sh",
        "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
        "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
      end
  end

  def caveats; <<-EOS.undent
    In Hadoop's config file:
      #{libexec}/etc/hadoop/hadoop-env.sh,
      #{libexec}/etc/hadoop/mapred-env.sh and
      #{libexec}/etc/hadoop/yarn-env.sh
    $JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home
    EOS
  end
end
