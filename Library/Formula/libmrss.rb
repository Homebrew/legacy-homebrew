require 'formula'

class Libmrss < Formula
  desc "C library for RSS files or streams"
  homepage 'http://www.autistici.org/bakunin/libmrss/'
  url 'http://www.autistici.org/bakunin/libmrss/libmrss-0.19.2.tar.gz'
  sha1 '3723b0f41151873de11eb56bb3743a4f72d446ce'

  bottle do
    cellar :any
    revision 1
    sha1 "e4dacacbaa4b228d3660a2fe3d4126539512a6df" => :yosemite
    sha1 "195152600295c55989c1c10f423a318f8c612227" => :mavericks
    sha1 "639128c63408fc8c6960bd8b17ab789418716bfa" => :mountain_lion
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
