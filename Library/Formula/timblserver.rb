require 'formula'

class Timblserver < Formula
  homepage 'http://ilk.uvt.nl/timbl/'
  url 'http://ilk.uvt.nl/downloads/pub/software/timblserver-1.4.tar.gz'
  sha1 '96f151747b55cf10da377ec2d1ddb681fec2e750'

  depends_on 'pkg-config' => :build
  depends_on 'timbl' => :build
  depends_on 'libxml2' => :build

  def install
    ENV['timbl_CFLAGS'] = "-I/usr/local/include/timbl -I/usr/include/libxml2"
    ENV['timbl_LIBS'] = "-L/usr/local/lib -ltimbl"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
