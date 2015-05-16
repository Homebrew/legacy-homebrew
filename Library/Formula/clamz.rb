require 'formula'

class Clamz < Formula
  homepage 'http://code.google.com/p/clamz/'
  url 'https://clamz.googlecode.com/files/clamz-0.5.tar.gz'
  sha1 '54664614e5098f9e4e9240086745b94fe638b176'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'libgcrypt'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/clamz"
  end
end
