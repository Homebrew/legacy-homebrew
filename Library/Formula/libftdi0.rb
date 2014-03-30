require 'formula'

class Libftdi0 < Formula
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.20.tar.gz"
  sha1 '4bc6ce70c98a170ada303fbd00b8428d8a2c1aa2'

  bottle do
    cellar :any
    sha1 "9a27fbda1e4b6832d36eadf8e8ef305f5db029d4" => :mavericks
    sha1 "d558f4f9a0754526df3f0c922e8029f9bc46c742" => :mountain_lion
    sha1 "f64321f62bfefa007fd8cdd6368bea682c0e3455" => :lion
  end

  depends_on 'libusb-compat'

  def install
    mkdir 'libftdi-build' do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
