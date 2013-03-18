require 'formula'

class Pgpdump < Formula
  homepage 'http://www.mew.org/~kazu/proj/pgpdump/en/'
  url 'http://www.mew.org/~kazu/proj/pgpdump/pgpdump-0.27.tar.gz'
  sha1 'dedfc75482503a335b67750f6fb2eb215448a413'

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    man1.mkpath
    system "make install"
  end

  test do
    system "#{bin}/pgpdump", "-v"
  end
end
