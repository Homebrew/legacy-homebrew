require 'formula'

class Arss < Formula
  homepage 'http://arss.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/arss/arss/0.2.3/arss-0.2.3-src.tar.gz'
  md5 '7a349ac00dd2732e70043254b4183255'

  depends_on 'cmake' => :build
  depends_on 'fftw'

  def install
    cd "src" do
      system "cmake", ".", *std_cmake_args
      system "make install"
    end
  end
end
