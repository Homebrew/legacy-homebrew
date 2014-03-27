require 'formula'

class Fastjar < Formula
  homepage 'http://sourceforge.net/projects/fastjar/'
  url 'https://downloads.sourceforge.net/project/fastjar/fastjar/0.94/fastjar-0.94.tar.gz'
  sha1 '2b54b558bed1acef63455b27827b69e83c823f8d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/fastjar", "-V"
    system "#{bin}/grepjar", "-V"
  end
end
