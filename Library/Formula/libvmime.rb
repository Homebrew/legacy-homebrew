require 'formula'

class Libvmime < Formula
  homepage 'http://www.vmime.org'
  url 'http://downloads.sourceforge.net/project/vmime/vmime/0.9/libvmime-0.9.1.tar.bz2'
  sha1 '3e8dd8855e423db438d465777efeb523c4abb5f3'

  depends_on "libgsasl"
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  fails_with :clang do
     build 318
  end
  def install
    args = %W[--prefix=#{prefix}
      LIBS=-liconv
      --disable-debug]

    system "./configure", *args
    system "make"
    system "make install"
  end

end
