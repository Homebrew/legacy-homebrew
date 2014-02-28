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
    [
      "https://gist.githubusercontent.com/MeckiCologne/9137957/raw/d450a29e47097554a5fb79cf1f770bb13c05be33/podofo1.patch",
      "https://gist.githubusercontent.com/MeckiCologne/9137957/raw/0e4eda9986652ff778ce95288adf4815c7c5699c/podofo2.patch",
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
