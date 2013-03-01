require 'formula'

class Podofo < Formula
  homepage 'http://podofo.sourceforge.net'
  url 'http://downloads.sourceforge.net/podofo/podofo-0.9.1.tar.gz'
  sha1 'd04c26b93dcf5f82a8dd90e02df6de95fb98ef47'

  depends_on 'cmake' => :build
  depends_on :libpng
  depends_on :freetype
  depends_on :fontconfig
  depends_on 'jpeg'
  depends_on 'libtiff'

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
