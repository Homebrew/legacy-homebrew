require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'https://polarssl.org/download/polarssl-1.3.7-gpl.tgz'
  sha1 '4bfce7f2e833bead53ecd38098325a784ada5c39'

  depends_on 'cmake' => :build

  conflicts_with 'md5sha1sum', :because => 'both install conflicting binaries'

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make install"
  end
end
