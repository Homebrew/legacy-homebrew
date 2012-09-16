require 'formula'

class TidyHtml5 < Formula
  head 'git://github.com/w3c/tidy-html5.git'
  homepage 'http://w3c.github.com/tidy-html5/'

  def install
    system "make",
        "-Cbuild/gmake",
        "-j1", # make fails with this Makefile when jobs > 1
        "runinst_prefix=#{prefix}",
        "devinst_prefix=#{prefix}",
        "maninst=#{prefix}/share/man",
        "install"
  end

  def test
    system "#{bin}/tidy", "-v"
  end
end

