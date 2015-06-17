require 'formula'

class Tcptunnel < Formula
  desc "TCP port forwarder"
  homepage 'http://www.vakuumverpackt.de/tcptunnel/'
  url 'https://github.com/vakuum/tcptunnel/archive/v0.8.tar.gz'
  sha1 '393e0496e89fbb362b7d40efe820456ea898c54c'

  def install
    bin.mkpath
    system "./configure", "--prefix=#{bin}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/tcptunnel", "--version"
  end
end
