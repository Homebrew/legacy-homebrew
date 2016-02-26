class Opentsdb < Formula
  desc "Scalable, distributed Time Series Database."
  homepage "http://opentsdb.net/"
  url "https://github.com/OpenTSDB/opentsdb/releases/download/v2.2.0/opentsdb-2.2.0.tar.gz"
  sha256 "5689d4d83ee21f1ce5892d064d6738bfa9fdef99f106f45d5c38eefb9476dfb5"

  option "without-lzo", "Don't use LZO Compression"

  depends_on "hbase" if build.without? "lzo"
  depends_on "hbase" => "with-lzo" if build.with? "lzo"
  depends_on :java => "1.6+"
  depends_on "gnuplot" => :optional

  def confdir
    etc/"opentsdb"
  end

  def cachedir
    var/"cache/opentsdb"
  end

  def hbasedir
    Formula["hbase"].opt_libexec.to_s
  end

  def hbase_plist
    Formula["hbase"].plist_name
  end

  def install
    inreplace "Makefile.in" do |s|
      s.sub!(/(\$\(jar\): manifest \.javac-stamp) \$\(classes\)/, '\1')
      s.sub!(/(echo " \$\(mkdir_p\) '\$\$dstdir'"; )/, '\1../')
    end

    mkdir "build" do
      system "../configure",
             "--disable-silent-rules",
             "--prefix=#{prefix}",
             "--mandir=#{man}"
      system "gmake"
      system "gmake", "install-exec-am"
      system "gmake", "install-data-am"
    end

    confdir.mkpath
    cachedir.mkpath
  end

  def post_install
    unless File.exist? "#{confdir}/opentsdb.conf"
      confdir.install Dir["#{opt_share}/opentsdb/etc/opentsdb/*"]
    end
    system "#{hbasedir}/bin/start-hbase.sh"
    envs = { "HBASE_HOME"=>hbasedir, "COMPRESSION"=>(build.with?("lzo") ? "LZO" : "NONE"), "JAVA_HOME"=>`/usr/libexec/java_home`.strip }
    Kernel.system(envs, "#{opt_share}/opentsdb/tools/create_table.sh")
  end

  plist_options :manual => "tsdb tsd --config=#{HOMEBREW_PREFIX}/etc/opentsdb/opentsdb.conf --staticroot=#{HOMEBREW_PREFIX}/opt/opentsdb/share/opentsdb/static/ --cachedir=#{HOMEBREW_PREFIX}/var/cache/opentsdb --port=4242 --zkquorum=localhost:2181 --zkbasedir=/hbase --auto-metric"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <dict>
        <key>OtherJobEnabled</key>
        <string>#{hbase_plist}</string>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/tsdb</string>
        <string>tsd</string>
        <string>--config=#{confdir}/opentsdb.conf</string>
        <string>--staticroot=#{opt_share}/opentsdb/static/</string>
        <string>--cachedir=#{cachedir}</string>
        <string>--port=4242</string>
        <string>--zkquorum=localhost:2181</string>
        <string>--zkbasedir=/hbase</string>
        <string>--auto-metric</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/opentsdb/opentsdb.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/opentsdb/opentsdb.err</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/tsdb", "version"
  end
end
