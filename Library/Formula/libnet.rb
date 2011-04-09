require 'formula'

class Libnet < Formula
  url "https://github.com/sam-github/libnet/tarball/libnet-1.1.4"
  md5 "0cb6c04063c1db37c91af08c76d25134"
  head 'git://github.com/sam-github/libnet.git'
  homepage 'https://github.com/sam-github/libnet'

  def install
    cd 'libnet'
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh"

    unless MacOS.leopard?
      cp "/usr/share/libtool/config/config.guess", "."
      cp "/usr/share/libtool/config/config.sub", "."
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    touch 'doc/man/man3/libnet.3'
    system "make install"
  end
end

