require 'formula'

class Libsvg < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/snapshots/libsvg-0.1.4.tar.gz'
  sha1 '2198e65833eed905d93be70f3db4f0d32a2eaf57'
  revision 1

  bottle do
    cellar :any
    sha1 "979610a80600f83956db765b442dabe647214107" => :mavericks
    sha1 "1237bff5e02721865d3d293d7369b6f3d685ef16" => :mountain_lion
    sha1 "bd21bd6ada56a3329a9e80105883da9114b0b9e6" => :lion
  end

  depends_on 'libpng'
  depends_on 'pkg-config' => :build
  depends_on 'jpeg'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
