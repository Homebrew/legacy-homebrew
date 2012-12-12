require 'formula'

class Chromaprint < Formula
  homepage 'http://acoustid.org/chromaprint'
  url 'https://github.com/downloads/lalinsky/chromaprint/chromaprint-0.7.tar.gz'
  sha1 '6a961585e82d26d357eb792216becc0864ddcdb2'

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
