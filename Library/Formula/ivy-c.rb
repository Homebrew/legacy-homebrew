require 'formula'

class IvyC < Formula
  homepage "http://www.tls.cena.fr/products/ivy/"
  #url "https://svn.tls.cena.fr/svn/ivy/ivy-c/trunk", :using => :svn, :revision => 3572
  url "https://github.com/esden/ivy-c.git", :branch => "some_improvements"
  #sha1 ""
  version "3.15"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'pcre'

  def install
    system "make", "-C", "src", "-f", "Makefile.osx", "PREFIX=#{prefix}", "install"
  end
end
