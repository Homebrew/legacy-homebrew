require 'formula'

class LcdfTypetools < Formula
  homepage 'http://www.lcdf.org/type/'
  url 'http://www.lcdf.org/type/lcdf-typetools-2.99.tar.gz'
  sha256 'cbb0ed8c42d078fb216b8f4b8ca7a29e0ad3c1969f580a6f2558c829a472adff'

  conflicts_with 'open-mpi', :because => 'both install same set of binaries.'

  def patches
    # fixes https://github.com/kohler/lcdf-typetools/issues/3
    "https://github.com/kohler/lcdf-typetools/commit/d263fdf688166d1eedffb776d4cc72815d561c52.patch"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make install"
  end
end
