require 'formula'

class Wipe < Formula
  url 'http://downloads.sourceforge.net/project/wipe/wipe/2.3.1/wipe-2.3.1.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fwipe%2Ffiles%2Fwipe%2F2.3.1%2F&ts=1321047066'
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
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test wipe`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end

