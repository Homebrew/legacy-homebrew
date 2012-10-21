require 'formula'

class Cloog < Formula
  homepage 'http://www.cloog.org/'
  url 'http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.17.0.tar.gz'
  sha1 'decc2221b1f1bd9238288d043835cb018af15d5a'

  depends_on 'pkg-config' => :build
  depends_on 'gmp'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    cloog_source = <<END
c

0 2
0

1

1
0 2
0 0 0
0

0
END

    pipe = IO.popen("cloog /dev/stdin", "w+")
    pipe.write(cloog_source)
    pipe.read =~ /Generated\ from \/dev\/stdin\ by\ CLooG/
  end
end
