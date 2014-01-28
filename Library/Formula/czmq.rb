require 'formula'

class Czmq < Formula
  homepage 'http://czmq.zeromq.org/'
  url 'http://download.zeromq.org/czmq-2.0.3.tar.gz'
  sha1 'df8e6d547f43545bcd058697a2476474f9e3a0c1'

  head do
    url 'https://github.com/zeromq/czmq.git'

    depends_on 'autoconf'
    depends_on 'automake'
    depends_on 'libtool'
  end

  option :universal

  depends_on 'zeromq'

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/czmq_selftest"
  end
end
