require 'formula'

class Qtscriptgenerator < Formula
  url 'http://qtscriptgenerator.googlecode.com/files/qtscriptgenerator-src-0.1.0.tar.gz'
  homepage 'http://code.google.com/p/qtscriptgenerator/'
  md5 'ca4046ad4bda36cd4e21649d4b98886d'

  # depends_on 'cmake' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
