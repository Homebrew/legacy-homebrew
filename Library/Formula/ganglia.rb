class Ganglia < Formula
  desc "Ganglia monitoring client"
  homepage "http://ganglia.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.6.0/ganglia-3.6.0.tar.gz"
  sha256 "89eae02e1a117040d60b3b561fe55f88d7f8cf41b94af1492969ef68e6797886"

  conflicts_with "coreutils", :because => "both install `gstat` binaries"

  depends_on "pkg-config" => :build
  depends_on :apr => :build
  depends_on "confuse"
  depends_on "pcre"
  depends_on "rrdtool"

  # fixes build on Leopard and newer, which lack kvm.h, cpu_steal_func() and its corresponding /dev/ node
  # merged upstream: https://github.com/ganglia/monitor-core/issues/150
  patch do
    url "https://github.com/ganglia/monitor-core/commit/ba942f.diff"
    sha256 "f339b43a4409c74a9cbe073041fed9e1512ad58b8bc3324a6a1e7c86df0ce7b2"
  end

  def install
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
end
