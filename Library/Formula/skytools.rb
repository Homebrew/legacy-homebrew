require 'formula'

class Skytools < Formula
  homepage 'http://pgfoundry.org/projects/skytools/'
  url 'http://pgfoundry.org/frs/download.php/3321/skytools-3.1.tar.gz'
  sha1 'f31fb7096f160fb959f8a217cbea529da04b277e'

  depends_on :postgresql

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
