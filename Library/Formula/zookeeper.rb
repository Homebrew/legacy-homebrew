class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  revision 1

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz"
    sha256 "01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994"

    # To resolve Yosemite build errors.
    # https://issues.apache.org/jira/browse/ZOOKEEPER-2049
    if MacOS.version == :yosemite
      patch :p0 do
        url "https://issues.apache.org/jira/secure/attachment/12673210/ZOOKEEPER-2049.noprefix.branch-3.4.patch"
        sha256 "b90eda47d21e60655dffe476eb437400afed24b37bbd71e7291faa8ece35c62b"
      end
    end
  end

  bottle do
    revision 1
    sha1 "4ef32a515592565bdf88546b9773725e4079a080" => :yosemite
    sha1 "c2db3e5bf5f66cd575a827842d667ec7f1acf6d0" => :mavericks
    sha1 "ac54b226852c9ec51477de8263bec2c767f7e842" => :mountain_lion
  end

  head do
    url "https://svn.apache.org/repos/asf/zookeeper/trunk"

    # To resolve Yosemite build errors.
    # https://issues.apache.org/jira/browse/ZOOKEEPER-2049
    if MacOS.version == :yosemite
      patch :p0 do
        url "https://issues.apache.org/jira/secure/attachment/12673212/ZOOKEEPER-2049.noprefix.trunk.patch"
        sha256 "64b5a4279a159977cbc1a1ab8fe782644f38ed04489b5a294d53aea74c84db89"
      end
    end

    depends_on "ant" => :build
    depends_on "cppunit" => :build
    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-perl", "Build Perl bindings"

  deprecated_option "perl" => "with-perl"

  depends_on :python => :optional

  def shim_script(target)
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
      ENV["ARCHFLAGS"] = "-arch #{Hardware::CPU.arch_32_bit}"
    else
      ENV["ARCHFLAGS"] = Hardware::CPU.universal_archs.as_arch_flags
    end

    if build.head?
      system "ant", "compile_jute"
      system "autoreconf", "-fvi", "src/c"
    end

    cd "src/c" do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--without-cppunit"
      system "make", "install"
    end

    if build.with? "python"
      cd "src/contrib/zkpython" do
        system "python", "src/python/setup.py", "build"
        system "python", "src/python/setup.py", "install", "--prefix=#{prefix}"
      end
    end

    if build.with? "perl"
      cd "src/contrib/zkperl" do
        system "perl", "Makefile.PL", "PREFIX=#{prefix}",
                                      "--zookeeper-include=#{include}",
                                      "--zookeeper-lib=#{lib}"
        system "make", "install"
      end
    end

    rm_f Dir["bin/*.cmd"]

    if build.head?
      system "ant"
      libexec.install Dir["bin", "src/contrib", "src/java/lib", "build/*.jar"]
    else
      libexec.install Dir["bin", "contrib", "lib", "*.jar"]
    end

    bin.mkpath
    (etc/"zookeeper").mkpath
    (var/"log/zookeeper").mkpath
    (var/"run/zookeeper/data").mkpath

    Pathname.glob("#{libexec}/bin/*.sh") do |path|
      next if path == libexec+"bin/zkEnv.sh"
      script_name = path.basename
      bin_name    = path.basename ".sh"
      (bin+bin_name).write shim_script(script_name)
    end

    defaults = etc/"zookeeper/defaults"
    defaults.write(default_zk_env) unless defaults.exist?

    log4j_properties = etc/"zookeeper/log4j.properties"
    log4j_properties.write(default_log4j_properties) unless log4j_properties.exist?

    inreplace "conf/zoo_sample.cfg",
              /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
    cp "conf/zoo_sample.cfg", "conf/zoo.cfg"
    (etc/"zookeeper").install ["conf/zoo.cfg", "conf/zoo_sample.cfg"]
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
