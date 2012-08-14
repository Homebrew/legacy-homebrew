require 'formula'

class Podofo < Formula
  homepage 'http://podofo.sourceforge.net'
  url 'http://downloads.sourceforge.net/podofo/podofo-0.9.1.tar.gz'
  md5 'cec586ab69f92bc88d38b5d4b8eee5a0'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build

  depends_on :x11
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'lua'

  def install
    mkdir 'build' do
      # Build shared to simplify linking for other programs.
      system "cmake", "..",
                      "-DPODOFO_BUILD_SHARED:BOOL=TRUE",
                      *std_cmake_args
      system "make install"
    end
  end
end
