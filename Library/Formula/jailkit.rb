class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "http://olivier.sessink.nl/jailkit/"
  url "http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.bz2"
  sha256 "bebbf6317a5a15057194dd2cf6201821c48c022dbc64c12756eb13b61eff9bf9"

  bottle do
    sha256 "9c46c69db017a018e9b4c92f613d99d22656d331962bef1da85c0ae782a172e1" => :el_capitan
    sha256 "b57b4205ede4e8dff0e09c386034e322f667ce4df739b02578579f844dfbe5e2" => :yosemite
    sha256 "dfd01ec63fdd8786b7bd224e3990ffb16f12f194c21bee144a2cd3b482d4d6b7" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
