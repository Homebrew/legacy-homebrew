require 'formula'

class Arss < Formula
  homepage 'http://arss.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/arss/arss/0.2.3/arss-0.2.3-src.tar.gz'
  sha1 'c78715dd9eeb9a5df594b09195256ac02a813313'

  depends_on 'cmake' => :build
  depends_on 'fftw'

  def install
    cd "src" do
      system "cmake", ".", *std_cmake_args
      system "make install"
    end
  end
end
