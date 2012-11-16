require 'formula'

class Skytools < Formula
  homepage 'http://pgfoundry.org/projects/skytools/'
  url 'http://pgfoundry.org/frs/download.php/3390/skytools-3.1.2.tar.gz'
  sha1 '47fef7abb4fab55b8987bff839a88afc4f4c717e'

  # Works only with homebrew postgres: https://github.com/mxcl/homebrew/issues/16024
  depends_on 'postgresql'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
