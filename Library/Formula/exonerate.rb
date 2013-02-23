require 'formula'

class Exonerate < Formula
  homepage 'http://www.ebi.ac.uk/~guy/exonerate/'
  url 'http://www.ebi.ac.uk/~guy/exonerate/exonerate-2.2.0.tar.gz'
  sha1 'ad4de207511e4d421e5cc28dda2261421c515bf0'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1
    system "make"
    system "make install"
  end
end
