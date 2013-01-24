require 'formula'

class Czmq < Formula
  homepage 'http://czmq.zeromq.org/'
  url 'http://download.zeromq.org/czmq-1.3.2.tar.gz'
  sha1 '09354c07cad4570d1360ad197c5f979c8f58847e'

  option :universal

  depends_on 'zeromq'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
