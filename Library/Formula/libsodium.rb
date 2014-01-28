require 'formula'

class Libsodium < Formula
  homepage 'https://github.com/jedisct1/libsodium/'
  url 'https://github.com/jedisct1/libsodium/releases/download/0.4.5/libsodium-0.4.5.tar.gz'
  sha256 '7ad5202df53eeac0eb29b064ae5d05b65d82b2fc1c082899c9c6a09b0ee1ac32'

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
