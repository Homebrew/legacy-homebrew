require 'formula'

class Zookeeper < Formula
  homepage 'http://zookeeper.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz'
  sha1 '2a9e53f5990dfe0965834a525fbcad226bf93474'

  bottle do
    sha1 "24842151e91e8b89d9b6bc2d706553bbcf31f6c0" => :mavericks
    sha1 "b53f4f1c7fb10f6e4997c88a886e1f4ec300e52d" => :mountain_lion
    sha1 "90a342133685c906e613cc949aa2b78818a18a24" => :lion
  end

  head do
    url 'http://svn.apache.org/repos/asf/zookeeper/trunk'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "c", "Build C bindings"
  option "perl", "Build Perl bindings"

  depends_on :ant => :build
  depends_on :python => :optional

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      . "#{etc}/zookeeper/defaults"
      cd "#{libexec}/bin"
      ./#{target} "$@"
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
      ENV['ARCHFLAGS'] = "-arch #{Hardware::CPU.arch_32_bit}"
    else
      ENV['ARCHFLAGS'] = Hardware::CPU.universal_archs.as_arch_flags
    end

    # Prep work for svn compile.
    if build.head?
      system "ant", "compile_jute"

      cd "src/c" do
        system "autoreconf", "-if"
      end
    end

    build_perl = build.include? "perl"
    build_c = build.with?('python') || build_perl || build.include?("c")

    # Build & install C libraries.
    cd "src/c" do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--without-cppunit"
      system "make install"
    end if build_c

    # Install Perl bindings
    cd "src/contrib/zkperl" do
      system "perl", "Makefile.PL", "PREFIX=#{prefix}",
                                    "--zookeeper-include=#{include}/c-client-src",
                                    "--zookeeper-lib=#{lib}"
      system "make install"
    end if build_perl

    # Remove windows executables
    rm_f Dir["bin/*.cmd"]

    # Install Java stuff
    if build.head?
      system "ant"
      libexec.install %w(bin src/contrib src/java/lib)
      libexec.install Dir['build/*.jar']
    else
      libexec.install %w(bin contrib lib)
      libexec.install Dir['*.jar']
    end

    # Create necessary directories
    bin.mkpath
    (etc+'zookeeper').mkpath
    (var+'log/zookeeper').mkpath
    (var+'run/zookeeper/data').mkpath

    # Install shim scripts to bin
    Pathname.glob("#{libexec}/bin/*.sh") do |path|
      next if path == libexec+'bin/zkEnv.sh'
      script_name = path.basename
      bin_name    = path.basename '.sh'
      (bin+bin_name).write shim_script(script_name)
    end

    # Install default config files
    defaults = etc/'zookeeper/defaults'
    defaults.write(default_zk_env) unless defaults.exist?

    log4j_properties = etc/'zookeeper/log4j.properties'
    log4j_properties.write(default_log4j_properties) unless log4j_properties.exist?

    inreplace 'conf/zoo_sample.cfg',
              /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
    cp 'conf/zoo_sample.cfg', 'conf/zoo.cfg'
    (etc/'zookeeper').install ['conf/zoo.cfg', 'conf/zoo_sample.cfg']
  end

  plist_options :manual => "zkServer start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
           <key>SERVER_JVMFLAGS</key>
           <string>-Dapple.awt.UIElement=true</string>
        </dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/zkServer</string>
          <string>start-foreground</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end
end
