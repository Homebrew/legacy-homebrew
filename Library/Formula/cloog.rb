require 'formula'

class Cloog < Formula
  homepage 'http://www.cloog.org/'
  url 'http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.17.0.tar.gz'
  sha1 'decc2221b1f1bd9238288d043835cb018af15d5a'

  depends_on 'pkg-config' => :build
  depends_on 'gmp'
  depends_on 'isl'

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-isl-prefix=#{Formula.factory('isl').opt_prefix}"
    ]

    system "./configure", *args
    system "make install"
  end

  def test
    cloog_source = <<-EOS.undent
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    pipe = IO.popen("cloog /dev/stdin", "w+")
    pipe.write(cloog_source)
    pipe.read =~ /Generated\ from \/dev\/stdin\ by\ CLooG/
  end
end
