require 'formula'

class Libyaml < Formula
  homepage 'https://bitbucket.org/xi/libyaml'
  url 'https://bitbucket.org/xi/libyaml/get/0.1.5.tar.gz'
  sha1 '060fdcfbab2bf2fb8b47a3b17e1f05ef2b8ad9e2'

  option :universal

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    ENV.universal_binary if build.universal?

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
