require 'formula'

class Libgsasl < Formula
  homepage 'http://www.gnu.org/software/gsasl/'
  url 'http://ftpmirror.gnu.org/gsasl/libgsasl-1.8.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gsasl/libgsasl-1.8.0.tar.gz'
  sha1 '08fd5dfdd3d88154cf06cb0759a732790c47b4f7'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
