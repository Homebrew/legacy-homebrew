require 'formula'

class Chromaprint < Formula
  homepage 'http://acoustid.org/chromaprint'
  url 'https://github.com/downloads/lalinsky/chromaprint/chromaprint-0.6.tar.gz'
  md5 '6b5a4f2685395e68d8abc40d1c2a8785'

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
