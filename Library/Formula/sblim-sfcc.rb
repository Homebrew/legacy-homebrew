require 'formula'

class SblimSfcc < Formula
  version  "2.2.7"
  homepage 'https://sourceforge.net/projects/sblim/'
  url      'http://downloads.sourceforge.net/project/sblim/sblim-sfcc/sblim-sfcc-2.2.7.tar.bz2'
  sha1     '487f30a06fe599ca17340d2ecfd3c32644c96c67'
  depends_on :libtool
  depends_on :autoconf
  depends_on :automake
  
  def install
    system "./configure","--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end


