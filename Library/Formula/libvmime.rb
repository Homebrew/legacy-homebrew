require 'formula'

class Libvmime < Formula
  homepage 'http://www.vmime.org'
  url 'http://downloads.sourceforge.net/project/vmime/vmime/0.9/libvmime-0.9.1.tar.bz2'
  sha1 '3e8dd8855e423db438d465777efeb523c4abb5f3'

  depends_on "pkg-config" => :build
  depends_on "libgsasl"
  depends_on "gnutls"
  fails_with :clang do
     build 318
     cause <<-EOS.undent
     ../vmime/base.hpp:255:12: error: use 'template' keyword to treat
     'dynamicCast' as a dependent template name
     EOS
  end
  def install
    system "./configure", "--prefix=#{prefix}", "LIBS=-liconv", "--disable-debug"
    system "make"
    system "make install"
  end
end
