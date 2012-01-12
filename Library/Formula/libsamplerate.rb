require 'formula'

class Libsamplerate < Formula
  homepage 'http://www.mega-nerd.com/SRC'
  url 'http://www.mega-nerd.com/SRC/libsamplerate-0.1.7.tar.gz'
  md5 '6731a81cb0c622c483b28c0d7f90867d'

  depends_on 'pkg-config' => :build
  depends_on 'libsndfile' => :optional

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
