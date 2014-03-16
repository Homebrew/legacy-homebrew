require 'formula'

class Epsilon < Formula
  homepage 'http://epsilon-project.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/epsilon-project/epsilon/0.9.2/epsilon-0.9.2.tar.gz'
  sha1 '050b0d2e35057c1a82f8927aceebe61a045c388e'

  depends_on 'popt'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
