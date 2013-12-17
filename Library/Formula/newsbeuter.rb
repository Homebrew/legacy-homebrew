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

  def patches
    # This fixes compilation with libc++. This is necessary on OS X >= 10.9.
    # See also: https://github.com/akrennmair/newsbeuter/issues/108
    "https://gist.github.com/sven-strothoff/7890891/raw/6b112d10b469c28d825d7f415695c321a87c137a/newsbeuter-r2.7-libc%2B%2B.patch" if MacOS.version >= "10.9" and ENV.compiler == :clang
  end
end
