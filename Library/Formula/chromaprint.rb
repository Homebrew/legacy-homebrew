require 'formula'

class Chromaprint < Formula
  homepage 'http://acoustid.org/chromaprint'
  url 'https://github.com/downloads/lalinsky/chromaprint/chromaprint-0.6.tar.gz'
  sha1 'e8bcc1d0d8dfec86aa648b87ba3f69b6d589eae0'

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
