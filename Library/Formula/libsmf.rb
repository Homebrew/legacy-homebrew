require 'formula'

class Libsmf < Formula
  homepage 'http://sourceforge.net/projects/libsmf/'
  url 'https://downloads.sourceforge.net/project/libsmf/libsmf/1.3/libsmf-1.3.tar.gz'
  sha1 'b2fb0ece095e77f04a9ff7532a88fe79533b2c47'

  bottle do
    cellar :any
    sha1 "0d0cc353ac631f8d368aa0d33c26afd9570dd3c0" => :mavericks
    sha1 "8a02ebe28c6bf851c979dc984362faba91ad0183" => :mountain_lion
    sha1 "4cf06bc29611951634e7916cd18bf01dbcb21252" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
