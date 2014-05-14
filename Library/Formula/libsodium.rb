require 'formula'

class Libsodium < Formula
  homepage 'https://github.com/jedisct1/libsodium/'
  url 'https://github.com/jedisct1/libsodium/archive/0.5.0.tar.gz'
  sha256 'f18e556447f9baebad6a90cbf23c426fc6211a186cb5ccd721cdf862da5e735e'

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
