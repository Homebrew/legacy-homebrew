require 'formula'

class HomebrewedPython < Requirement
  fatal true

  satisfy(:build_env => false) { Formula.factory('python').installed? }

  def message; <<-EOS.undent
    Compiling against the system-provided Python will likely fail.
    The system-provided Python includes PPC support, which will cause a compiler
    mis-match. This formula is known to work against a Homebrewed Python.

    Patches to correct this issue are welcome.
    EOS
  end
end

class CmuSphinxbase < Formula
  homepage 'http://cmusphinx.sourceforge.net/'
  url 'http://sourceforge.net/projects/cmusphinx/files/sphinxbase/0.8/sphinxbase-0.8.tar.gz'
  sha1 'c0c4d52e143d07cd593bd6bcaeb92b9a8a5a8c8e'

  depends_on 'pkg-config' => :build
  depends_on HomebrewedPython

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
