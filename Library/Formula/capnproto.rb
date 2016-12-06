require 'formula'

class Capnproto < Formula
  homepage 'http://kentonv.github.io/capnproto'
  url 'http://capnproto.org/capnproto-c++-0.2.1.tar.gz'
  sha1 'd546ddcf69b2bec09be47723bcab2ae3675243cb'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/capnp"
  end
end
