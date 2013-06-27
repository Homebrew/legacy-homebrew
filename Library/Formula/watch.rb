require 'formula'

class Watch < Formula
  homepage 'https://github.com/whit537/watch'
  url 'http://gitorious.org/procps/procps/archive-tarball/v3.3.0'
  version '0.3.0'
  sha1 'e51631aeaa005d99080d0a3621ffb13f36fc1d96'

  depends_on "pkg-config" => :build
  depends_on "automake"   => :build
  depends_on "autoconf"   => :build
  depends_on "libtool"    => :build

  def install
    system "rm -rf autom4te.cache"
    system "glibtoolize"
    system "aclocal", "-I", "m4"
    system "autoconf"
    system "autoheader"
    system "automake", "--add-missing"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  def test
    system "#{bin}/watch", "-v"
  end
end
