require 'formula'

class Libbson < Formula
  homepage 'https://github.com/mongodb/libbson'
  url 'https://github.com/mongodb/libbson/releases/download/0.4.0/libbson-0.4.0.tar.gz'
  sha1 '3652df214a14728b2d3075ef97f727b55ff3f17c'

  depends_on :automake

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
