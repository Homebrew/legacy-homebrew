require 'formula'

class Libestr < Formula
  homepage 'http://libestr.adiscon.com'
  url 'http://libestr.adiscon.com/files/download/libestr-0.1.8.tar.gz'
  sha256 'ce18565af57adc219799fe1659baaa70f58f169795882d770a7a2fe8ca8a6615'

  bottle do
    cellar :any
    sha1 "0c5bb3a440fd72793000777a91b0a778e9fdad84" => :mavericks
    sha1 "da5421c53fbda80c61766b1d919b8a8fed75f5ae" => :mountain_lion
    sha1 "cbab735e202fc8e86fee5edb2f27c14e32ecca6f" => :lion
  end

  depends_on 'pkg-config' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
