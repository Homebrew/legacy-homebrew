require 'formula'

class HomebrewedPython < Requirement
  def message; <<-EOS.undent
    Compiling against the system-provided Python will likely fail.
    The system-provided Python includes PPC support, which will cause a compiler
    mis-match. This formula is known to work against a Homebrewed Python.

    Patches to correct this issue are welcome.
    EOS
  end
  def satisfied?
    Formula.factory('python').installed?
  end
  def fatal?
    false
  end
end

class CmuSphinxbase < Formula
  homepage 'http://cmusphinx.sourceforge.net/'
  url 'http://sourceforge.net/projects/cmusphinx/files/sphinxbase/0.7/sphinxbase-0.7.tar.gz'
  sha1 '32dc04f7e7f37ffe53bd0b6e27b1f5df1800a705'

  depends_on 'pkg-config' => :build
  depends_on HomebrewedPython.new

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
