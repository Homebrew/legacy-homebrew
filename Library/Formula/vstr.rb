require 'formula'

class Vstr < Formula
  homepage 'http://www.and.org/vstr/'
  url 'http://www.and.org/vstr/1.0.15/vstr-1.0.15.tar.bz2'
  sha1 '4d2c19cb83f30239b3800abc5c9eda4f24dd0b78'

  depends_on 'pkg-config' => :build

  def install
    ENV.append 'CFLAGS', '--std=gnu89' if ENV.compiler == :clang
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
