require 'formula'

class Ganglia < Formula
  homepage 'http://ganglia.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.1.7/ganglia-3.1.7.tar.gz'
  sha1 'e234d64814af1c9f55f1cd039a5840039d175f85'

  depends_on 'confuse'
  depends_on 'pcre'
  depends_on 'rrdtool'

  def patches
    # fixes build on Leopard and newer, which lack kvm.h and its corresponding /dev/ node
    {:p0 => [
      "https://trac.macports.org/export/105820/trunk/dports/net/ganglia/files/patch-libmetrics-darwin-metrics.c.diff"
    ]}
  end

  def install
    # ENV var needed to confirm putting the config in the prefix until 3.2
    ENV['GANGLIA_ACK_SYSCONFDIR'] = '1'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--with-gexec",
                          "--with-gmetad",
                          "--with-libpcre=#{HOMEBREW_PREFIX}"
    system "make install"

    cd "web" do
      system "make", "conf.php"
      system "make", "version.php"
      inreplace "conf.php", "/usr/bin/rrdtool", "#{HOMEBREW_PREFIX}/bin/rrdtool"
    end

    # Generate the default config file
    system "#{bin}/gmond -t > #{etc}/gmond.conf" unless File.exists? "#{etc}/gmond.conf"

    # Install the web files
    (share+"ganglia").install "web"

    # Install man pages
    man1.install Dir['mans/*']
  end

  def caveats; <<-EOS.undent
    If you didn't have a default config file, one was created here:
      #{etc}/gmond.conf

    You might want to copy these someplace served by a PHP-capable web server:
      #{share}/ganglia/web/* to someplace
    EOS
  end
end
