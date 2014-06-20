require 'formula'

class Libcec < Formula
  homepage 'http://libcec.pulse-eight.com/'
  url 'https://github.com/Pulse-Eight/libcec/archive/libcec-2.1.4.tar.gz'
  sha1 '3ee241201b3650b97ec4fc41b0f5dd33476080f9'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/cec-client", "--info"
  end
end
