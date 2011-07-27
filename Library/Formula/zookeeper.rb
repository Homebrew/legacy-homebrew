require 'formula'

class Zookeeper < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=zookeeper/zookeeper-3.3.3/zookeeper-3.3.3.tar.gz'
  head 'http://svn.apache.org/repos/asf/zookeeper/trunk'
  homepage 'http://zookeeper.apache.org/'
  md5 'aa4129c6eebb50dbd6b640c9c3aa21f0'

  def options
    [
      ["--perl", "Build Perl bindings."],
      ["--python", "Build Python bindings."],
    ]
  end

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      . "#{etc}/zookeeper/defaults"
      cd #{libexec}/bin
      ./#{target} $*
    EOS
  end

  def default_zk_env
    <<-EOS.undent
      export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def default_log4j_properties
    <<-EOS.undent
      log4j.rootCategory=WARN, zklog

      log4j.appender.zklog = org.apache.log4j.FileAppender
      log4j.appender.zklog.File = #{var}/log/zookeeper/zookeeper.log
      log4j.appender.zklog.Append = true
      log4j.appender.zklog.layout = org.apache.log4j.PatternLayout
      log4j.appender.zklog.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %c{1} [%p] %m%n
    EOS
  end

  def install
    # Don't try to build extensions for PPC
    if Hardware.is_32_bit?
      ENV['ARCHFLAGS'] = "-arch i386"
    else
      ENV['ARCHFLAGS'] = "-arch i386 -arch x86_64"
    end

    # Prep work for svn compile.
    if ARGV.build_head?
      system "ant", "compile_jute"

      cd "src/c" do
        system "autoreconf", "-if"
      end
    end

    # Build & install C libraries.
    cd "src/c" do
      system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--without-cppunit"
      system "make install"
    end

    # Install Python bindings
    cd "src/contrib/zkpython" do
      system "python", "src/python/setup.py", "build"
      system "python", "src/python/setup.py", "install", "--prefix=#{prefix}"
    end if ARGV.include? "--python"

    # Install Perl bindings
    cd "src/contrib/zkperl" do
      system "perl", "Makefile.PL", "PREFIX=#{prefix}", "--zookeeper-include=#{include}/c-client-src", "--zookeeper-lib=#{lib}"
      system "make install"
    end if ARGV.include? "--perl"

    # Remove windows executables
    rm_f Dir["bin/*.cmd"]

    # Install Java stuff
    if ARGV.build_head?
      system "ant"
      libexec.install %w(bin src/contrib src/java/lib)
      libexec.install Dir['build/*.jar']
    else
      libexec.install %w(bin contrib lib)
      libexec.install Dir['*.jar']
    end

    # Create neccessary directories
    bin.mkpath
    (etc+'zookeeper').mkpath
    (var+'log/zookeeper').mkpath
    (var+'run/zookeeper/data').mkpath

    # Install shim scripts to bin
    Dir["#{libexec}/bin/*.sh"].map { |p| Pathname.new p }.each { |path|
      next if path == libexec+'bin/zkEnv.sh'
      script_name = path.basename
      bin_name    = path.basename '.sh'
      (bin+bin_name).write shim_script(script_name)
    }

    # Install default config files
    defaults = etc+'zookeeper/defaults'
    defaults.write(default_zk_env) unless defaults.exist?

    log4j_properties = etc+'zookeeper/log4j.properties'
    log4j_properties.write(default_log4j_properties) unless log4j_properties.exist?

    unless (etc+'zookeeper/zoo.cfg').exist?
      inreplace 'conf/zoo_sample.cfg', /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
      (etc+'zookeeper').install 'conf/zoo_sample.cfg'
    end
  end
end
