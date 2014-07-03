require 'formula'

class Libnxml < Formula
  homepage 'http://www.autistici.org/bakunin/libnxml/'
  url 'http://www.autistici.org/bakunin/libnxml/libnxml-0.18.3.tar.gz'
  sha1 '2bcb17ea01aa953d0f8cbc116e025bb837bec4aa'

  bottle do
    cellar :any
    sha1 "6073c9e0141cd295bf3132f27a28d5db7d84aeb0" => :mavericks
    sha1 "2d8a948bf2b6b12f03a7289375674792746b7d11" => :mountain_lion
    sha1 "0cafd82425ece9802a6a3cdf330edcd80b6c644e" => :lion
  end

  depends_on 'curl' if MacOS.version < :lion # needs >= v7.20.1

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
