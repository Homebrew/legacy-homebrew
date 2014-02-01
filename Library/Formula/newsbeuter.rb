require 'formula'

class Newsbeuter < Formula
  homepage 'http://newsbeuter.org/'
  url 'http://www.newsbeuter.org/downloads/newsbeuter-2.8.tar.gz'
  sha1 'de284124c840062941b500ffbd72e3f183fb2b61'

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
