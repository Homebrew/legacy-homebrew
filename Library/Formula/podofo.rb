require 'formula'

class Podofo < Formula
  homepage 'http://podofo.sourceforge.net'
  url 'http://downloads.sourceforge.net/podofo/podofo-0.9.2.tar.gz'
  sha1 '8a6e27e17e0ed9f12e1a999cff66eae8eb97a4bc'

  depends_on 'cmake' => :build
  depends_on :libpng
  depends_on :freetype
  depends_on :fontconfig
  depends_on 'jpeg'
  depends_on 'libtiff'

  def patches
    # fixes compilation on Mavericks (fixed ios includes, fixed freetype 2.5.1 includes)
    # fixes compilation on Lion (fixed CommonCrypto include)
    # upstream bug report: http://sourceforge.net/p/podofo/mailman/message/32039124/
    [
      "https://gist.githubusercontent.com/MeckiCologne/9599737/raw/784809a9288daa251f59a1cfd3fec9762df5830b/podofo.patch",
    ]
  end

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
