require 'formula'

class Libass < Formula
  url 'http://libass.googlecode.com/files/libass-0.10.0.tar.gz'
  homepage 'http://code.google.com/p/libass/'
  sha1 '82bfda2b78f74cf75a4dd0283d090ad1a71a697f'

  depends_on 'pkg-config' => :build
  depends_on 'fribidi'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
