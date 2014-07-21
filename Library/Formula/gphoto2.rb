require 'formula'

class Gphoto2 < Formula
  homepage 'http://gphoto.org/'
  url 'https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.4/gphoto2-2.5.4.tar.bz2'
  sha1 'c557ee5cdea28f6cff1d2bc1d6ace58be48b65d3'

  bottle do
    cellar :any
    sha1 "11a6058dda360a35674e156c324d9973d039ee33" => :mavericks
    sha1 "8e82208a1cc540b6dca788d0ed1c0b4d0f8ec779" => :mountain_lion
    sha1 "459af859c8a218d45ecbb36228afde156f3fccab" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libgphoto2'
  depends_on 'popt'
  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
