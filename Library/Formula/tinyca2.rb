require 'formula'

class Tinyca2 < Formula
  homepage 'http://www.sm-zone.net/'
  url 'http://www.sm-zone.net/tinyca2-0.7.5.tar.bz2'
  sha1 'd3f1372d4e6962d982d847d79cee3a6a53326f4d'

  depends_on :x11
  depends_on 'Gtk2' => :perl

  def install
    inreplace 'tinyca2' do |s|
      s.gsub! /.\/lib/, lib
      s.gsub! /\/bin\/tar/, '/usr/bin/tar'
      s.gsub! /.\/templates/, share
    end

    lib.install Dir['lib/*']
    share.install Dir['templates/*']
    bin.install "tinyca2"
  end

  def test
    system "perl -cX #{bin}/tinyca2"
  end
end
