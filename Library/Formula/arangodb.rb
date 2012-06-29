require 'formula'

class Arangodb < Formula
  homepage 'http://www.arangodb.org/'
  url "https://github.com/triAGENS/ArangoDB/zipball/v1.0.alpha2"
  sha1 'd6e90221dcc02252ae9bb66085a797d495be5bc4'

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
