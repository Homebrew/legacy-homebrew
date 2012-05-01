require 'formula'

class Libnet < Formula
  homepage 'https://github.com/sam-github/libnet'
  url 'http://sourceforge.net/projects/libnet-dev/files/libnet-1.1.6.tar.gz'
  sha1 'dffff71c325584fdcf99b80567b60f8ad985e34c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

