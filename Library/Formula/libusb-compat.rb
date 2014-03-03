require 'formula'

class LibusbCompat < Formula
  homepage 'http://www.libusb.org/'
  url 'https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2'
  sha256 '404ef4b6b324be79ac1bfb3d839eac860fbc929e6acb1ef88793a6ea328bc55a'

  bottle do
    cellar :any
    sha1 "d267d8bbd870f618a031b22619579aca32a26593" => :mavericks
    sha1 "f4c86e75411aa6b66a83436ce6f74c4d6b56d8ca" => :mountain_lion
    sha1 "47125454bee7245d91d230394c7e208a5c3a72c7" => :lion
  end

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'libusb'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
