require 'formula'

class Skytools < Formula
  url 'http://pgfoundry.org/frs/download.php/2872/skytools-2.1.12.tar.gz'
  homepage 'http://pgfoundry.org/projects/skytools/'
  md5 '94f3391d5b3c3ac6c2edcbfbda705573'
  version '2.1.12'

  depends_on 'postgresql'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
