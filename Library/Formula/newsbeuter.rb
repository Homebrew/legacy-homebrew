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

  def patches
    # This fixes compilation with libc++. This is necessary on OS X >= 10.9.
    # See also: https://github.com/akrennmair/newsbeuter/issues/108
    "https://gist.github.com/sven-strothoff/7890891/raw/6b112d10b469c28d825d7f415695c321a87c137a/newsbeuter-r2.7-libc%2B%2B.patch" if MacOS.version >= "10.9" and ENV.compiler == :clang
  end
end
