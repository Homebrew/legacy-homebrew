require 'formula'

class Libbson < Formula
  homepage 'https://github.com/mongodb/libbson'
  url 'https://github.com/mongodb/libbson/releases/download/0.2.4/libbson-0.2.4.tar.gz'
  sha1 '53972c042f7d453e172132fe499b21a216746b9d'

  depends_on :automake

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
