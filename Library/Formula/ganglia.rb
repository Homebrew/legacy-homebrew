require 'formula'

class Ganglia < Formula
  homepage 'http://ganglia.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.6.0/ganglia-3.6.0.tar.gz'
  sha1 'b06529ac49deb1f1c65c6215b8d2d13c3f3fa23f'

  conflicts_with 'coreutils', :because => 'both install `gstat` binaries'

  depends_on 'pkg-config' => :build # to find APR
  depends_on 'confuse'
  depends_on 'pcre'
  depends_on 'rrdtool'

  # fixes build on Leopard and newer, which lack kvm.h, cpu_steal_func() and its corresponding /dev/ node
  # merged upstream: https://github.com/ganglia/monitor-core/issues/150
  patch do
    url "https://github.com/ganglia/monitor-core/commit/ba942f.diff"
    sha1 "f79c4973634d127052e262c22d11e1fec82b5677"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--with-gmetad",
                          "--with-libpcre=#{HOMEBREW_PREFIX}"
    system "make install"

    # Generate the default config file
    system "#{bin}/gmond -t > #{etc}/gmond.conf" unless File.exist? "#{etc}/gmond.conf"

    # Install man pages
    man1.install Dir['mans/*']
  end

  def caveats; <<-EOS.undent
    If you didn't have a default config file, one was created here:
      #{etc}/gmond.conf
    EOS
  end
end
