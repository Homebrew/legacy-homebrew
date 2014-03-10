require 'formula'

class Yaz < Formula
  homepage 'http://www.indexdata.com/yaz'
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-5.0.18.tar.gz'
  sha1 '2e273f38b90597298ecc9b254a92367158582aa6'

  bottle do
    cellar :any
    sha1 "077badcd55b5b7fb3de0dee94792264bdfe8fbb9" => :mavericks
    sha1 "d61a12ae149b31950eb00cd8dbe21e6bfba6e2aa" => :mountain_lion
    sha1 "eba1bc0073340ba998081ed8113eb487d8f254db" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'gnutls' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml2"
    system "make install"
  end
end
