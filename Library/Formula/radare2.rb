require 'formula'

class Radare2 < Formula
  homepage 'http://radare.org'
  url 'https://github.com/radare/radare2/archive/4a5165f232.tar.gz'
  sha1 'd9eece2accc7598906383cadb7334d99c2713134'
  version '0.9.7git'
  head 'https://github.com/radare/radare2.git'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version'

  depends_on 'libewf'
  depends_on 'libmagic'
  depends_on 'gmp'
  depends_on 'lua'
  depends_on "openssl" if MacOS.version <= :leopard or build.with?('brewed-openssl')

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-ostype=darwin",
    ]
    if build.with? 'brewed-openssl'
      args << "--with-openssl=#{Formula.factory('openssl').opt_prefix}"
    elsif MacOS.version > :leopard
      # For Xcode-only systems we help a bit to find openssl.
      # If CLT.installed?, it evaluates to "/usr", which works.
      args << "--with-openssl=#{MacOS.sdk_path}/usr"
    end

    system "./configure", *args

    system "make"
    system "make install"
  end
end
