require 'formula'

class Skytools < Formula
  homepage 'http://pgfoundry.org/projects/skytools/'
  url 'http://pgfoundry.org/frs/download.php/3622/skytools-3.2.tar.gz'
  sha1 '8e6e0f594c1c97e138ca6a3c1e621f5433de2559'

  # Works only with homebrew postgres:
  # https://github.com/Homebrew/homebrew/issues/16024
  depends_on 'postgresql'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
