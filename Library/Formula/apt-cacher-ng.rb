class AptCacherNg < Formula
  desc "Caching proxy"
  homepage "https://www.unix-ag.uni-kl.de/~bloch/acng/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.8.8.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.8.8.orig.tar.xz"
  sha256 "7847f970ed9b3b3b65fe9c302107ede9cd0c5de57e3ddb497a409e8720f1fe58"

  bottle do
    sha256 "a1df0128f290116cb8e5e9d9bcf899dda1bba6ba4bdc6a4827e0839bd2631854" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on :osxfuse => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "xz" # For LZMA

  needs :cxx11

  if MacOS.version <= :mavericks
    # clang++ 3.5 (Mavericks) fails to compile because it cannot deduce the
    # lambda return type due to multiple returns and, in the case of clang++ 3.5,
    # lambdas would preserve cv-qualifiers.  These are DRs (defect reports) to
    # C++11, of which clang++ 3.5 is affected.  A decent summary of thesse issues
    # can be found in the link below.
    # https://stackoverflow.com/questions/28955478/when-can-we-omit-the-return-type-in-a-c11-lambda
    #
    # Raised https://alioth.debian.org/tracker/index.php?func=detail&aid=315276&group_id=100566&atid=413109
    # with upstream to address.
    patch :DATA
  end

  def install
    ENV.cxx11

    (var/"spool/apt-cacher-ng").mkpath
    (var/"log").mkpath

    inreplace "conf/acng.conf.in" do |s|
      s.gsub!(/^CacheDir: .*/, "CacheDir: #{var}/spool/apt-cacher-ng")
      s.gsub!(/^LogDir: .*/, "LogDir: #{var}/log")
    end

    system "cmake", ".", *std_cmake_args
    system "make", "apt-cacher-ng"
    system "make", "install"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>OnDemand</key>
      <false/>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/apt-cacher-ng</string>
        <string>-c</string>
        <string>#{etc}/apt-cacher-ng</string>
        <string>foreground=1</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"var/log").mkpath
    (testpath/"var/spool").mkpath
    logs = "LogDir=#{testpath}/var/log"
    cache = "CacheDir=#{testpath}/var/spool"

    pid = fork do
      exec "#{sbin}/apt-cacher-ng", "-c", "#{etc}/apt-cacher-ng", logs, cache
    end
    sleep 2

    begin
      assert_match(/Not Found or APT Reconfiguration required/, shell_output("curl localhost:3142"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/source/acfg.cc b/source/acfg.cc
index fe9867d..922f16b 100644
--- a/source/acfg.cc
+++ b/source/acfg.cc
@@ -180,7 +180,7 @@ tProperty n2pTbl[] =
		BARF("Invalid proxy specification, aborting...");
	}
	return true;
-}, [](bool superUser)
+}, [](bool superUser) -> string
 {
	if(!superUser && !proxy_info.sUserPass.empty())
		return string("#");
