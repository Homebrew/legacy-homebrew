require 'formula'

class Libtiff < Formula
  url 'http://www.imagemagick.org/download/delegates/tiff-3.9.4.zip'
  homepage 'http://www.remotesensing.org/libtiff/'
  md5 '95b112997641096d97344b1a5dc61e71'

  # depends_on 'cmake'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end


