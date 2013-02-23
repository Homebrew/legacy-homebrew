require 'formula'

class Confuse < Formula
  homepage 'http://www.nongnu.org/confuse/'
  url 'http://savannah.nongnu.org/download/confuse/confuse-2.7.tar.gz'
  sha1 'b3f74f9763e6c9012476dbd323d083af4be34cad'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
