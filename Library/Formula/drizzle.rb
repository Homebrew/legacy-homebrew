require 'formula'

class LionOrNewer < Requirement
  satisfy MacOS.version >= :lion

  def message
    "Drizzle requires Mac OS X 10.7 (Lion) or newer."
  end
end

class Drizzle < Formula
  homepage 'http://drizzle.org'
  url 'https://launchpad.net/drizzle/7.1/7.1.36/+download/drizzle-7.1.36-stable.tar.gz'
  sha1 '6ce317d6a6b0560e75d5bcf44af2e278443cfbfe'

  depends_on 'intltool' => :build
  depends_on LionOrNewer

  # https://github.com/mxcl/homebrew/issues/14289
  depends_on 'boost149'
  depends_on 'protobuf'
  depends_on 'libevent'
  depends_on 'pcre'
  depends_on 'libgcrypt'
  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
