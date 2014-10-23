require 'formula'

class GlobusToolkit < Formula
  homepage 'http://www.globus.org/toolkit/'
  url 'http://toolkit.globus.org/ftppub/gt5/5.2/5.2.5/installers/src/gt5.2.5-all-source-installer.tar.gz'
  version '5.2.5'
  sha1 '2e39065e0c3970b660e081705915d45640d3c350'

  bottle do
    sha1 "b0a24a8d66dd36aa0ac48f0ae5dddfd02af22d6c" => :yosemite
    sha1 "a9e19f50eed7f13d0200c107aabe20751071bc9b" => :mavericks
    sha1 "1cbbe7a3d08711cbc5665e91558417d7b2028d3a" => :mountain_lion
  end

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
