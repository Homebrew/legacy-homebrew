require 'formula'

class Libestr < Formula
  homepage 'http://libestr.adiscon.com'
  url 'http://libestr.adiscon.com/files/download/libestr-0.1.8.tar.gz'
  sha256 'ce18565af57adc219799fe1659baaa70f58f169795882d770a7a2fe8ca8a6615'

  depends_on 'pkg-config' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
