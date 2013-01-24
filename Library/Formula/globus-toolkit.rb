require 'formula'

class GlobusToolkit < Formula
  homepage 'http://www.globus.org/toolkit/'
  url 'http://www.globus.org/ftppub/gt5/5.2/5.2.3/installers/src/gt5.2.3-all-source-installer.tar.gz'
  version '5.2.3'
  sha1 '47b1d6579adbd5b62accffbb69bd8d9deeb75236'

  depends_on :libtool

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
