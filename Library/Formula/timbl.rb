require 'formula'

class Timbl < Formula
  homepage 'http://ilk.uvt.nl/timbl/'
  url 'http://ilk.uvt.nl/downloads/pub/software/timbl-6.4.2.tar.gz'
  md5 'c4485b22c4ad1c7fc15e273706988a02'

  depends_on 'pkg-config' => :build
  depends_on 'libxml2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
