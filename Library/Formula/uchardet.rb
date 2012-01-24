require 'formula'

class Uchardet < Formula
  url 'http://uchardet.googlecode.com/files/uchardet-0.0.1.tar.gz'
  homepage 'http://code.google.com/p/uchardet/'
  md5 '9c17f0aca38c66c95d400691a9160b1b'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "uchardet", __FILE__
  end
end
