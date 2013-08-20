require 'formula'

class Uberftp < Formula
  homepage 'http://dims.ncsa.illinois.edu/set/uberftp/'
  url 'https://github.com/JasonAlt/UberFTP/archive/Version_2_7.tar.gz'
  sha1 'f185e2ed567eca3484ca230e44a6ffdb4ec69792'
  version '2.7'

  depends_on 'globus-toolkit'

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", 
                          "--with-globus-flavor=gcc32dbg", 
                          "--with-globus=#{Formula.factory('globus-toolkit').opt_prefix}"
    system "make"
    system "make install"
  end

  test do
      system "#{bin}/uberftp", "-v"
  end
end
