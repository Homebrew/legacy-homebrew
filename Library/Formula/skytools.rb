require 'formula'

class Skytools < Formula
  homepage 'http://pgfoundry.org/projects/skytools/'
  url 'http://pgfoundry.org/frs/download.php/3397/skytools-3.1.3.tar.gz'
  sha1 'c94eb1d86f9b33e49b929e02cefda95150e2fdcf'

  # Works only with homebrew postgres: https://github.com/mxcl/homebrew/issues/16024
  depends_on 'postgresql'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
