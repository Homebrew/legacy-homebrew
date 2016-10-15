require 'formula'

class Tcptunnel < Formula
  homepage 'http://www.vakuumverpackt.de/tcptunnel/'
  url 'https://github.com/vakuum/tcptunnel/archive/v0.8.tar.gz'
  sha1 '393e0496e89fbb362b7d40efe820456ea898c54c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "tcptunnel"
  end

  test do
    system "#{bin}/tcptunnel", "--version"
  end
end
