require 'formula'

class CapnprotoCxx < Formula
  homepage 'http://kentonv.github.io/capnproto/'
  url 'http://capnproto.org/capnproto-c++-0.4.0.tar.gz'
  sha1 '1d356a0229a9c6b3665930a4b166b91cba03825b'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/capnp", "--version"
  end
end

