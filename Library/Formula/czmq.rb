require 'formula'

class Czmq < Formula
  homepage 'http://czmq.zeromq.org/'
  url 'http://download.zeromq.org/czmq-2.0.2.tar.gz'
  sha1 '9a78ea2bf2100863eefdd0512c77486ebd1e2587'

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
