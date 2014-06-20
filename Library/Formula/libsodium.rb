require 'formula'

class Libsodium < Formula
  homepage 'https://github.com/jedisct1/libsodium/'
  url 'https://github.com/jedisct1/libsodium/releases/download/0.5.0/libsodium-0.5.0.tar.gz'
  sha256 '3ca0a0619199a2adb3449eb7f1bf6e1f4fb2ef8514da9133f7f043b8b5cdf9f0'

  head do
    url 'https://github.com/jedisct1/libsodium.git'

    depends_on 'libtool' => :build
    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
