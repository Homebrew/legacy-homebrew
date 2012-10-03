require 'formula'

class GlobusToolkit < Formula
  homepage 'http://www.globus.org/toolkit/'
  url 'http://www.globus.org/ftppub/gt5/5.2/5.2.2/installers/src/gt5.2.2-all-source-installer.tar.gz'
  version '5.2.2'
  sha1 '0e59f1dbd2c9f13cca42bef442922d3e5702cfd8'

  depends_on 'libtool' => :build

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
