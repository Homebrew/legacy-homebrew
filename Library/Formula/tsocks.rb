require 'formula'

class Tsocks < Formula
  homepage 'http://tsocks.sourceforge.net/'
  url 'http://downloads.sourceforge.net/tsocks/tsocks-1.8beta5.tar.gz'
  md5 '51caefd77e5d440d0bbd6443db4fc0f8'

  def patches
    {:p1 => 'https://raw.github.com/gist/1132721/04a58ab9a1b7f6334c57bd3f2b4268b768b27442/tsocks-1.8-osx.patch'}
  end

  def install
    system "autoreconf -ivf"
    system "./configure", "--prefix=#{prefix}", "--exec-prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    bin.install "tsocks"
    etc.install %w(tsocks.conf.complex.example tsocks.conf.simple.example)
    lib.install Dir["*.dylib", "*.dylib.*"]
    man1.install "tsocks.1"
  end
end
