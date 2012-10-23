require 'formula'

class Lastfmfpclient < Formula
  homepage 'https://github.com/lastfm/Fingerprinter'
  url 'https://github.com/lastfm/Fingerprinter/tarball/9ee83a51ac9058ff53c9'
  version '1.6'
  sha1 'dcb10b1bad1f1af30b43f1828f83c262e6dfb6df'

  depends_on 'cmake' => :build
  depends_on 'taglib'
  depends_on 'fftw'
  depends_on 'mad'
  depends_on 'libsamplerate'

  def inreplace_fix
    # This project was made on Windows (LOL), patches against Windows
    # line-endings fail for some reason, so we will inreplace instead.
    # Fixes compile with clang failure due to entirely missing variable, how
    # the fuck did GCC ever compile this?!
    inreplace 'fplib/src/FloatingAverage.h',
      'for ( int i = 0; i < size; ++i )',
      'for ( int i = 0; i < m_values.size(); ++i )'
  end

  def install
    inreplace_fix
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
