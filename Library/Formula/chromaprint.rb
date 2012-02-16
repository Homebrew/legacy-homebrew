require 'formula'

class Chromaprint < Formula
  homepage 'http://acoustid.org/chromaprint'
  url 'https://github.com/downloads/lalinsky/chromaprint/chromaprint-0.6.tar.gz'
  md5 '6b5a4f2685395e68d8abc40d1c2a8785'

  def options
    [['--without-examples', "Don't build examples (including fpcalc)"]]
  end

  depends_on 'cmake' => :build
  depends_on 'ffmpeg' unless ARGV.include? '--without-examples'

  def install
    if ARGV.include? '--without-examples'
      parameters = std_cmake_parameters
    else
      parameters = std_cmake_parameters + ' -DBUILD_EXAMPLES=ON'
    end
    system "cmake . #{parameters}"
    system "make install"
  end
end
