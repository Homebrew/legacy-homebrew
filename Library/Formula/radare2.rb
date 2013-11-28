require 'formula'

class Radare2 < Formula
  homepage 'http://radare.org'
  url 'https://github.com/radare/radare2/archive/0.9.6.tar.gz'
  sha1 'a0f6103adb9e7f17084b9553fd1629673a1d14ef'

  head 'https://github.com/radare/radare2.git'

  depends_on 'libewf'
  depends_on 'libmagic'
  depends_on 'gmp'
  depends_on 'lua'
  depends_on "openssl" if MacOS.version <= :leopard

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-ostype=darwin",
    ]

    if MacOS.version > :leopard
      # For Xcode-only systems we help a bit to find openssl.
      # If CLT.installed?, it evaluates to "/usr", which works.
      args << "--with-openssl=#{MacOS.sdk_path}/usr"
    else
      args << "--with-openssl=#{Formula.factory('openssl').opt_prefix}"
    end

    system "./configure", *args

    # "Do not use a parallel 'make'."
    ENV.deparallelize
    system "make"
    system "make install"
  end
end
