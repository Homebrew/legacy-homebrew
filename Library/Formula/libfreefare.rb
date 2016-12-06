require 'formula'

class Libfreefare < Formula
  homepage 'https://code.google.com/p/libfreefare/'
  url 'https://libfreefare.googlecode.com/files/libfreefare-0.3.4.tar.gz'
  sha1 '0c89c655341a0334cc506aad18fd676c6b39dee9'

  depends_on 'pkg-config' => :build

  depends_on 'libnfc'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
