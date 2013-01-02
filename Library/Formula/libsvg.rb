require 'formula'

class Libsvg < Formula
  url 'http://cairographics.org/snapshots/libsvg-0.1.4.tar.gz'
  homepage 'http://cairographics.org/'
  sha1 '2198e65833eed905d93be70f3db4f0d32a2eaf57'

  depends_on :libpng
  depends_on 'pkg-config' => :build
  depends_on 'jpeg'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
