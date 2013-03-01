require 'formula'

class Twemcache < Formula
  homepage 'https://github.com/twitter/twemcache'
  head 'https://github.com/twitter/twemcache.git'
  url "https://github.com/twitter/twemcache/archive/v2.5.3.tar.gz"
  sha256 '05371d9ed123e01286ea74d9bd1af892be548b84bb24da98118a67a1ec876845'

  option "enable-debug", "Debug mode with assertion panics enabled"

  depends_on :automake
  depends_on 'libevent'

  def install
    # After the deprecation of GitHub Downloads, we don't have distribution
    # downloads anymore.  Everything is now a repository download from version
    # tags.
    system "autoreconf", "-ivf"

    args = ["--prefix=#{prefix}"]
    if build.include? "enable-debug"
      ENV['CFLAGS'] += "-ggdb3 -O0"
      args << "--enable-debug=full"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end
end
