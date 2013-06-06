require 'formula'

class Newsbeuter < Formula
  homepage 'http://newsbeuter.org/'
  url 'http://newsbeuter.org/downloads/newsbeuter-2.6.tar.gz'
  sha1 '36f6f4028b1432f0b679090610645700ec6146b8'

  head 'https://github.com/akrennmair/newsbeuter.git'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'json-c'
  depends_on 'libstfl'
  depends_on 'sqlite'

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end
end
