require 'formula'

class Drizzle < Formula
  homepage 'http://drizzle.org'
  url 'https://launchpad.net/drizzle/7.1/7.1.36/+download/drizzle-7.1.36-stable.tar.gz'
  sha1 '6ce317d6a6b0560e75d5bcf44af2e278443cfbfe'

  depends_on 'protobuf'

  # https://github.com/mxcl/homebrew/issues/14289
  depends_on 'boost149'

  depends_on 'libevent'
  depends_on 'pcre'
  depends_on 'intltool'
  depends_on 'libgcrypt'
  depends_on 'gnu-readline'

  def install

    old_boost = Formula.factory('boost149')

    ENV.append 'LDFLAGS', "-L#{old_boost.prefix}/lib"
    ENV.append 'CPPFLAGS', "-I#{old_boost.prefix}/include"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
