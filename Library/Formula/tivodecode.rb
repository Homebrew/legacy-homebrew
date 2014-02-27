require 'formula'

class Tivodecode < Formula
  homepage 'http://tivodecode.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/tivodecode/tivodecode/0.2pre4/tivodecode-0.2pre4.tar.gz'
  sha1 'efabe4aee461e6da90ddc52abe9ae025c4185032'
  version '0.2pre4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
