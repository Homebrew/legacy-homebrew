require 'formula'

class Libsmf < Formula
  homepage 'http://sourceforge.net/projects/libsmf/'
  url 'https://downloads.sourceforge.net/project/libsmf/libsmf/1.3/libsmf-1.3.tar.gz'
  sha1 'b2fb0ece095e77f04a9ff7532a88fe79533b2c47'

  bottle do
    cellar :any
    revision 1
    sha1 "0f0e51b213d978ecd8c8a55b7432895b44631803" => :yosemite
    sha1 "5e51896c19b99ca8936e191f1e340f642676d6e1" => :mavericks
    sha1 "132000d2bd832712926b330736d02eabbfca0ee7" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
