require 'formula'

class Avocadodb < Formula
  url "https://github.com/triAGENS/AvocadoDB/zipball/v0.2.2"
  head "https://github.com/triAGENS/AvocadoDB.git"

  homepage 'http://www.avocadodb.org/'
  sha1 '497d175e703be57a0b4bd227c7dbd75b58631c3c'

  depends_on 'libev'
  depends_on 'v8'
  depends_on 'boost' => :build

  def install
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
    Please note that this is a very early version of AvocadoDB. There will be
    bugs and it would be really appreciated it if you report them:

      https://github.com/triAGENS/AvocadoDB/issues

    To start AvocadoDB, run:
        avocado

    To start AvocadoDB with an interactive (REPL) shell, run:
        avocado --shell
    EOS
  end
end
