require 'formula'

class Arangodb < Formula
  homepage 'http://www.arangodb.org/'
  url "https://github.com/triAGENS/ArangoDB/zipball/v0.5.0"
  sha1 'a3b49fe19bc15e52b5d2a47ee083cc76cb80bbd8'

  head "https://github.com/triAGENS/ArangoDB.git"

  depends_on 'libev'
  depends_on 'v8'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-relative",
                          "--disable-all-in-one",
                          "--enable-mruby",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--datadir=#{share}",
                          "--localstatedir=#{var}"

    system "make install"

    (var+'arango').mkpath
  end

  def caveats; <<-EOS.undent
    Please note that this is a very early version if ArangoDB. There will be
    bugs and the ArangoDB team would really appreciate it if you report them:

      https://github.com/triAGENS/ArangoDB/issues

    To start the ArangoDB server, run:
        /usr/local/sbin/arangod

    To start the ArangoDB shell, run:
        arangosh
    EOS
  end
end
