require 'formula'

class Libyaml < Formula
  homepage 'https://bitbucket.org/xi/libyaml'
  url 'https://bitbucket.org/xi/libyaml/get/0.1.4.tar.gz'
  sha1 'ec13162bff400b4c65f563e5ac226961c8a44446'

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
