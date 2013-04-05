require 'formula'

class Gecode < Formula
  homepage 'http://www.gecode.org/'
  url 'http://www.gecode.org/download/gecode-4.0.0.tar.gz'
  sha1 'a1137f89fd527d47d183b3d8e38bc5d52a65b954'

  option 'without-gist', 'Build without Gist interactive tool (Gist requires Qt)'
  option 'with-mpfr', 'Build with trig/transcendental float constraints (requires gmp)'

  depends_on 'mpfr' if build.with? 'mpfr'
  depends_on 'gmp' if build.with? 'mpfr'
  depends_on 'qt' if build.with? 'gist'

  def install
    args = ["--prefix=#{prefix}",
            "--disable-examples"]
    if build.with? 'mpfr'
      args << "-with-gmp-include=#{HOMEBREW_PREFIX}/include"
      args << "-with-gmp-lib=#{HOMEBREW_PREFIX}/lib"
      args << "-with-mpfr-include=#{HOMEBREW_PREFIX}/include"
      args << "-with-mpfr-lib=#{HOMEBREW_PREFIX}/lib"
    end
    if build.without? 'gist'
      args << "-disable-qt"
      args << "-disable-gist"
    end
    system "./configure", *args
    system "make install"
  end
end
