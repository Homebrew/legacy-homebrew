require 'formula'

class Timbl < Formula
  homepage 'http://ilk.uvt.nl/timbl/'
  url 'http://ilk.uvt.nl/downloads/pub/software/timbl-6.4.2.tar.gz'
  sha1 '7479ace6b7856205e2a3431c8df380fb1ec2a03f'

  depends_on 'pkg-config' => :build
  depends_on 'libxml2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
