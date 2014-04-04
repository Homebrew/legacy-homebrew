require 'formula'

class Openjpeg < Formula
  homepage 'http://www.openjpeg.org/'
  url 'https://downloads.sourceforge.net/project/openjpeg.mirror/openjpeg-2.0.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fopenjpeg.mirror%2Ffiles%2F%3Fsource%3Ddlp'
  sha1 '0af78ab2283b43421458f80373422d8029a9f7a7'

  head 'http://openjpeg.googlecode.com/svn/trunk/'

  depends_on "cmake" => :build

  depends_on 'little-cms2'
  depends_on 'libtiff'
  depends_on 'libpng'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
