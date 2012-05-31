require 'formula'

class Cloog < Formula
  url 'http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.16.3.tar.gz'
  homepage 'http://www.cloog.org/'
  md5 'a0f8a241cd1c4f103f8d2c91642b3498'

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
