require 'formula'

class Libvpx <Formula
  url 'http://webm.googlecode.com/files/libvpx-v0.9.5.tar.bz2'
  sha1 '223965ff16737251afb3377c0800d1f8b5f84379'
  homepage 'http://www.webmproject.org/code/'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
