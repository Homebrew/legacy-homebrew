require 'formula'

class Ykpers < Formula
  homepage 'http://yubico.github.io/yubikey-personalization/'
  url 'https://developers.yubico.com/yubikey-personalization/releases/ykpers-1.16.1.tar.gz'
  sha1 'ff7cf92551ee06da198a2cccd29d55b388ce172b'

  bottle do
    cellar :any
    sha1 "b8a65fc072e38b677064a6341b0d78a598f45bf4" => :yosemite
    sha1 "f4e714cd3a13837431524f5610d9dc1dafce6e48" => :mavericks
    sha1 "a74127ef74af9f3ac9220a69259aeb286da16b6c" => :mountain_lion
  end

  option :universal

  depends_on 'libyubikey'
  depends_on 'json-c' => :recommended
  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    libyubikey_prefix = Formula["libyubikey"].opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          "--with-backend=osx"
    system "make", "check"
    system "make", "install"
  end
end
