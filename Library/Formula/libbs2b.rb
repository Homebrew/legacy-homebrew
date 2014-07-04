require 'formula'

class Libbs2b < Formula
  homepage 'http://bs2b.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz'
  sha1 'a71318211611a00bd3d595b0830d2188938ff89d'

  bottle do
    cellar :any
    sha1 "2a571c586d841c5a738502a769850f1f14a7b021" => :mavericks
    sha1 "a54117fe5502cdef097fd829f9c6c6436230439e" => :mountain_lion
    sha1 "bec684ed5d6c8210b0c0ac5dcc76fddbb200cee9" => :lion
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
