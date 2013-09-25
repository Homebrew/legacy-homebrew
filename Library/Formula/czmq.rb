require 'formula'

class Czmq < Formula
  homepage 'http://czmq.zeromq.org/'
  url 'http://download.zeromq.org/czmq-1.4.1.tar.gz'
  sha1 '8ddb485e9d53bca6bb703c850be40b8da70c4d74'

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
end
