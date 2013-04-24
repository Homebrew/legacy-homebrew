require 'formula'

class Bfgminer < Formula
  homepage 'https://github.com/luke-jr/bfgminer'
  url 'http://luke.dashjr.org/programs/bitcoin/files/bfgminer/3.0.1/bfgminer-3.0.1.zip'
  sha1 '17c26e9ba2fa23d9a34512ec8d9439ddf3f47b30'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'curl'
  depends_on 'jansson'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "PKG_CONFIG_PATH=/usr/local/opt/curl/lib/pkgconfig:/usr/local/opt/jansson/lib/pkgconfig",
                          "--enable-scrypt"
    system "make", "install"
  end

  test do
    system "bfgminer"
  end
end
