require 'formula'

class Chromaprint < Formula
  homepage 'http://acoustid.org/chromaprint'
  url 'https://bitbucket.org/acoustid/chromaprint/downloads/chromaprint-1.0.tar.gz'
  sha1 '919e012af588a7e6fea862b29a30e3a5da67526a'

  option 'without-examples', "Don't build examples (including fpcalc)"

  depends_on 'cmake' => :build
  depends_on 'ffmpeg' unless build.include? 'without-examples'

  def install
    args = std_cmake_args
    args << '-DBUILD_EXAMPLES=ON' unless build.include? 'without-examples'
    system "cmake", ".", *args
    system "make install"
  end
end
