require 'formula'

class Newsbeuter < Formula
  homepage 'http://newsbeuter.org/'
  url 'http://newsbeuter.org/downloads/newsbeuter-2.7.tar.gz'
  sha1 'e49e00b57b98dacc95ce73ddaba91748665e992c'

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
