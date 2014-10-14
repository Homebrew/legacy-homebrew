require 'formula'

class Libmrss < Formula
  homepage 'http://www.autistici.org/bakunin/libmrss/'
  url 'http://www.autistici.org/bakunin/libmrss/libmrss-0.19.2.tar.gz'
  sha1 '3723b0f41151873de11eb56bb3743a4f72d446ce'

  bottle do
    cellar :any
    sha1 "fe2bb6d0b1d869d36a87db51512a37f6d1cb8b74" => :mavericks
    sha1 "a553e758df554af1b2620ed086f4ee3deabbb325" => :mountain_lion
    sha1 "48b819d85c99a9b84eff59c3904758478f4d2dab" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libnxml'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
