require 'formula'

class Ykclient < Formula
  homepage 'http://yubico.github.io/yubico-c-client/'
  url 'http://yubico.github.io/yubico-c-client/releases/ykclient-2.12.tar.gz'
  sha1 '518ce53ba9ef61a619f9150778f19fad23014a9c'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'help2man' => :build

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
