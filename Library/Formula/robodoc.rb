require 'formula'

class Robodoc < Formula
  url 'http://rfsber.home.xs4all.nl/Robo/robodoc-4.99.41.tar.gz'
  md5 '986ff954e0ba5a9c407384fc4b05303d'
  homepage 'http://rfsber.home.xs4all.nl/Robo/robodoc.html'
  head 'https://github.com/gumpu/ROBODoc.git'

  def install
    system "autoreconf", "-f", "-i" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
