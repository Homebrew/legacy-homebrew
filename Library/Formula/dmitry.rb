require 'formula'

class Dmitry < Formula
  homepage 'http://mor-pah.net/software/dmitry-deepmagic-information-gathering-tool/'
  url 'http://dl.packetstormsecurity.net/UNIX/misc/DMitry-1.3a.tar.gz'
  version '1.3a'
  sha1 'ed242375b5629270593795e6de45c61d3953bdda'

  def install
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
