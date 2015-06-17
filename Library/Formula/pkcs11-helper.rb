require 'formula'

class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage 'https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper'
  url 'https://github.com/OpenSC/pkcs11-helper/archive/pkcs11-helper-1.11.tar.gz'
  sha1 '45c84c58430ec749e98d05c9e10a66412b7db739'

  head 'https://github.com/OpenSC/pkcs11-helper.git'

  depends_on 'autoconf' => :build
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
