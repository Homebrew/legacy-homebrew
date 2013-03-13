require 'formula'

class Pkcs11Helper < Formula
  homepage 'https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper'
  url 'https://github.com/OpenSC/pkcs11-helper/archive/pkcs11-helper-1.10.tar.gz'
  sha1 '9737c2f76b277571a8b12cfc3600cf2e076e8623'

  head 'https://github.com/OpenSC/pkcs11-helper.git'

  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build

  def install
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
