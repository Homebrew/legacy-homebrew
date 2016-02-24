class Ganglia < Formula
  desc "Scalable distributed monitoring system"
  homepage "http://ganglia.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.7.1/ganglia-3.7.1.tar.gz"
  sha256 "e735a6218986a0ff77c737e5888426b103196c12dc2d679494ca9a4269ca69a3"

  bottle do
    revision 1
    sha256 "6398320db597d246d1076183c0a23fe951044d4cdf62a412212c7e822b38dc4e" => :el_capitan
    sha256 "d81e70de25b2d384e1d06c4fde604810b587c2411df3428378e3bc89a6de10ce" => :yosemite
    sha256 "1abf670ffa1d4a75fd1301d9386e3be1f7d6c9b2b4804ec8fc7cfdc91e93aadb" => :mavericks
  end

  head do
    url "https://github.com/ganglia/monitor-core.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "coreutils", :because => "both install `gstat` binaries"

  depends_on "pkg-config" => :build
  depends_on :apr => :build
  depends_on "confuse"
  depends_on "pcre"
  depends_on "rrdtool"

  def install
    if build.head?
      inreplace "bootstrap", "libtoolize", "glibtoolize"
      inreplace "libmetrics/bootstrap", "libtoolize", "glibtoolize"
      system "./bootstrap"
    end

    inreplace "configure", %(varstatedir="/var/lib"), %(varstatedir="#{var}/lib")
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--with-gmetad",
                          "--with-libpcre=#{Formula["pcre"].opt_prefix}"
    system "make", "install"

    # Generate the default config file
    system "#{bin}/gmond -t > #{etc}/gmond.conf" unless File.exist? "#{etc}/gmond.conf"
  end

  def post_install
    (var/"lib/ganglia/rrds").mkpath
  end

  def caveats; <<-EOS.undent
    If you didn't have a default config file, one was created here:
      #{etc}/gmond.conf
    EOS
  end

  test do
    begin
      pid = fork do
        exec bin/"gmetad", "--pid-file=#{testpath}/pid"
      end
      sleep 2
      File.exist? testpath/"pid"
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
