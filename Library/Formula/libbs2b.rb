require 'formula'

class Libbs2b < Formula
  desc "Bauer stereophonic-to-binaural DSP"
  homepage 'http://bs2b.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz'
  sha1 'a71318211611a00bd3d595b0830d2188938ff89d'

  bottle do
    cellar :any
    revision 1
    sha1 "ec0656043ebafa2c7fe71f9577d3edb8d0d2cb48" => :yosemite
    sha1 "7d89520466e0755a3b536f2940dc067478e9b05c" => :mavericks
    sha1 "248d58ff800499e8ff97f8ab7357f3aa604a8ce4" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libsndfile'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-static",
                          "--enable-shared"
    system "make install"
  end
end
