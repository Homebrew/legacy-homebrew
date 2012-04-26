require 'formula'

class Avocadodb < Formula
  homepage 'http://www.avocadodb.org/'
  url "https://github.com/triAGENS/AvocadoDB/zipball/v0.3.9"
  sha1 '95ac8035b709d3c5849dabe2f5cf8475142d9b48'

  head "https://github.com/triAGENS/AvocadoDB.git"

  depends_on 'libev'
  depends_on 'v8'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-relative",
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
    bugs and the AvocadoDB team would really appreciate it if you report them:

      https://github.com/triAGENS/AvocadoDB/issues

    To start the AvocadoDB server, run:
        avocado

    To start the AvocadoDB shell, run:
        avocsh
    EOS
  end
end
