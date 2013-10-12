require 'formula'

class Kimwituxx < Formula
  homepage 'http://www2.informatik.hu-berlin.de/sam/kimwitu++/'
  url 'http://download.savannah.gnu.org/releases/kimwitu-pp/kimwitu++-2.3.13.tar.gz'
  sha1 'a3bd57a9edf6534eebcd43d128ca94a0aef68a2b'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end
end
