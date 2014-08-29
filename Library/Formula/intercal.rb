require 'formula'

class Intercal < Formula
  homepage 'http://catb.org/~esr/intercal/'
  url 'http://catb.org/~esr/intercal/intercal-0.29.tar.gz'
  sha1 '6f496b158e5f9dbf05a81c5e75f2d61698e65b15'

  bottle do
    sha1 "6a3fe7a08a8e51baf99acefe92db529a8d709504" => :mavericks
    sha1 "73c12c6f3befaa5f40e475d21c089ae94a6a05a7" => :mountain_lion
    sha1 "11f6c85f85c879c95369e4b7b6c548c8a6489e1f" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/convickt"
    system "#{bin}/ick"
  end
end
