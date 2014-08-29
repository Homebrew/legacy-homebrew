require 'formula'

class GlobusToolkit < Formula
  homepage 'http://www.globus.org/toolkit/'
  url 'http://toolkit.globus.org/ftppub/gt5/5.2/5.2.5/installers/src/gt5.2.5-all-source-installer.tar.gz'
  version '5.2.5'
  sha1 '2e39065e0c3970b660e081705915d45640d3c350'

  depends_on "libtool" => :run

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
    share.install prefix/'man'
  end
end
