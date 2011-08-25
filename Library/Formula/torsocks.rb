require 'formula'

class Torsocks < Formula
  url 'http://torsocks.googlecode.com/files/torsocks-1.1.tar.gz'
  homepage 'http://code.google.com/p/torsocks/'
  md5 '1704fd009ed1a1c1dc9c6b72305a5449'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
