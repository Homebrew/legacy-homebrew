require 'formula'

class Libnet < Formula
  head 'git://github.com/sam-github/libnet.git'
  homepage 'http://github.com/sam-github/libnet'

  def install
    cd 'libnet'
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    touch 'doc/man/man3/libnet.3'
    system "make install"
  end
end

