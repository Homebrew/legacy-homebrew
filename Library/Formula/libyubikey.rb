require 'formula'

class Libyubikey < Formula
  homepage 'http://yubico.github.io/yubico-c/'
  url 'http://yubico.github.io/yubico-c/releases/libyubikey-1.11.tar.gz'
  sha1 'a939abc129ed66af193d979765a8d8ac59ad7c40'

  bottle do
    cellar :any
    sha1 "e5cf353256f4e7ca7b18e00aeb9976eb772070e9" => :mavericks
    sha1 "1b6c9c26b3cd5fd49fd9eae477b7cc2edd35e314" => :mountain_lion
    sha1 "d7e5fbe2f2bbc8ac385f2b044539c686484357a4" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
