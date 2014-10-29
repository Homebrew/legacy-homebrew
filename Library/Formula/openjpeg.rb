require 'formula'

class Openjpeg < Formula
  homepage 'http://www.openjpeg.org/'
  url 'https://openjpeg.googlecode.com/files/openjpeg-1.5.1.tar.gz'
  sha1 '1b0b74d1af4c297fd82806a9325bb544caf9bb8b'
  revision 1

  bottle do
    cellar :any
    sha1 "c4f3c9cc6bbc264aa7f1a4aefc06c6fa75596a14" => :yosemite
    sha1 "c93cbb9697d0ec93eb90673861387220f6ec0f13" => :mavericks
    sha1 "adf2186e0a1962e495cd6e1d17ec89087dd48635" => :mountain_lion
  end

  head 'http://openjpeg.googlecode.com/svn/trunk/'

  depends_on 'little-cms2'
  depends_on 'libtiff'
  depends_on 'libpng'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
