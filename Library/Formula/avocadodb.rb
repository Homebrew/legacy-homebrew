require 'formula'

class Avocadodb < Formula
  url "https://github.com/triAGENS/AvocadoDB/zipball/v0.1.2"
  head "https://github.com/triAGENS/AvocadoDB.git"

  homepage 'http://www.avocadodb.org/'
  sha1 '3867395bd7bd3dcd847ff0103971bf0095a20086'

  depends_on 'libev'
  depends_on 'v8'
  depends_on 'boost'

  # force distributor to bundle a configure and not depend on automake!
  depends_on "automake" if MacOS.xcode_version >= "4.3"

  def install
    system "make setup"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-all-in-one",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--datadir=#{share}",
                          "--localstatedir=#{var}"

    system "make install"

    (var+'avocado').mkpath
  end

  def caveats; <<-EOS.undent
    Please note that this is a very early version if AvocadoDB. There will be
    bugs and we'd realy appreciate it if you report them:

      https://github.com/triAGENS/AvocadoDB/issues

    To start AvocadoDB, run:
        avocado

    To start AvocadoDB with an interactive (REPL) shell, run:
        avocado --shell
    EOS
  end
end