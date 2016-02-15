class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "http://lftp.yar.ru/"
  url "http://lftp.yar.ru/ftp/lftp-4.6.5.tar.xz"
  sha256 "1fd0920a1791ce0e9e39ffce77ae6619e5dc665f16e9380bafbfc69411eeb71e"

  bottle do
    sha256 "f341d62601963f968e46907f88e1e96d21154deb2b60d97bd3bac27a37816575" => :el_capitan
    sha256 "182979ca79b7ea9d9e70e9fefab990d5d238da709ce0e17edf5ec7166b976fb1" => :yosemite
    sha256 "dc44f63a8f1767af2b4ed2008c199377eabd117339f01ee17bb73aa844cf3dee" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open ftp://mirrors.kernel.org; ls"
  end
end
