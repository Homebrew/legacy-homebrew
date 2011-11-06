require 'formula'

class Epsilon < Formula
  homepage 'http://epsilon-project.sourceforge.net'
  url 'http://sourceforge.net/projects/epsilon-project/files/epsilon/0.9.2/epsilon-0.9.2.tar.gz'
  md5 '56d7f1a41e05be20441728d9e20d22ef'

  depends_on 'popt'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
