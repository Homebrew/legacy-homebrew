require 'formula'

class Wipe < Formula
  url 'http://downloads.sourceforge.net/project/wipe/wipe/2.3.1/wipe-2.3.1.tar.bz2'
  homepage 'http://wipe.sourceforge.net/'
  md5 '3aed00711e0490edbec115bc283b8544'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--mandir=#{man}", "--prefix=#{prefix}"
    inreplace 'Makefile' do |s|
      s.gsub! /-o root/, ''
      s.gsub! /\/man1\//, ''
    end

    system "make install"
  end

  def test
    system "wipe"
  end
end

