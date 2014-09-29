require 'formula'

class Ykpers < Formula
  homepage 'http://yubico.github.io/yubikey-personalization/'
  url 'https://developers.yubico.com/yubikey-personalization/releases/ykpers-1.16.0.tar.gz'
  sha1 '2536d8882d2b56303c3e9a089d92eb97a688fac6'

  bottle do
    cellar :any
    sha1 "c6899d1553428cc61c1be94854b2e32ed4d85c0f" => :mavericks
    sha1 "457639f87ec9056a36194f951cd13d55a2faeab7" => :mountain_lion
    sha1 "798fbbaf1b9d51075cca1cfe4bd11e50b4c58623" => :lion
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
