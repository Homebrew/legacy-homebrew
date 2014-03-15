require 'formula'

class Libbson < Formula
  homepage 'https://github.com/mongodb/libbson'
  url 'https://github.com/mongodb/libbson/releases/download/0.6.4/libbson-0.6.4.tar.gz'
  sha1 '70fa36361fa43aad0a0d429e4b159b6de8dd464f'

  depends_on :automake

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
