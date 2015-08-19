class Valkyrie < Formula
  desc "GUI for Memcheck and Helgrind tools in Valgrind 3.6.X"
  homepage "http://valgrind.org/downloads/guis.html"
  url "http://valgrind.org/downloads/valkyrie-2.0.0.tar.bz2"
  sha256 "a70b9ffb2409c96c263823212b4be6819154eb858825c9a19aad0ae398d59b43"

  head "svn://svn.valgrind.org/valkyrie/trunk"

  depends_on "qt"
  depends_on "valgrind"

  def install
    system "qmake", "PREFIX=#{prefix}"
    system "make", "install"
    prefix.install bin/"valkyrie.app"
  end
end
