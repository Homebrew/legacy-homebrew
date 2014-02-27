require 'formula'

class Lame < Formula
  homepage 'http://lame.sourceforge.net/'
  url 'https://downloads.sourceforge.net/sourceforge/lame/lame-3.99.5.tar.gz'
  sha1 '03a0bfa85713adcc6b3383c12e2cc68a9cfbf4c4'

  bottle do
    cellar :any
    sha1 "2c082ab45be931a4b1215775f90b6dccb65af00d" => :mavericks
    sha1 "d74f4bb8458ae47050e5f6aa0c5583a3623e2c25" => :mountain_lion
    sha1 "98cf6f0f8db0aa4d1684dec1706085a375d19ba5" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-nasm"
    system "make install"
  end
end
