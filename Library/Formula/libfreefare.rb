require 'formula'

class Libfreefare < Formula
  homepage 'https://code.google.com/p/libfreefare/'
  url 'https://libfreefare.googlecode.com/files/libfreefare-0.4.0.tar.bz2'
  sha1 '74214069d6443a6a40d717e496320428a114198c'

  bottle do
    cellar :any
    sha1 "88c8244fd0d36f704b2987f17d9765f987ff72e6" => :mavericks
    sha1 "043120f7f4af8d80795c7568e2d83076c3c101a2" => :mountain_lion
    sha1 "7b561b71f1ef12892c7cd830fa3445ee664c44ab" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libnfc'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
