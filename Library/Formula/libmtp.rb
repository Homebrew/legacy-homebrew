require 'formula'

class Libmtp < Formula
  homepage 'http://libmtp.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.6/libmtp-1.1.6.tar.gz'
  sha1 'f9e55c75399fc5f4deabcdfa58e1b01b2e6e3283'

  bottle do
    cellar :any
    sha1 "7702b0ce097a9a6a100d0b32f3df153d52ff28fb" => :mavericks
    sha1 "8ceb62bf1932a223bfc3601309f37886d81c6b1f" => :mountain_lion
    sha1 "6c629f67821477825bfd8f17ecbc1745a308b08e" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make install"
  end
end
