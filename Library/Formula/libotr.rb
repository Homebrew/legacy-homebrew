require 'formula'

class Libotr < Formula
  homepage 'http://www.cypherpunks.ca/otr/'
  url 'http://www.cypherpunks.ca/otr/libotr-4.0.0.tar.gz'
  sha1 '8865e9011b8674290837afcf7caf90c492ae09cc'

  bottle do
    cellar :any
    sha1 "f49e2b138533aa7777b12cb5fdf5d86f5f5db72b" => :mavericks
    sha1 "e36eb2e9cb4a32c07d0c78d60ef5d1d7031c1706" => :mountain_lion
    sha1 "5f80d7daeb377eb938a0166b6c21901fad271eab" => :lion
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
