require 'formula'

class Mongrel2 < Formula
  url 'http://mongrel2.org/static/downloads/mongrel2-1.7.5.tar.bz2'
  head 'https://github.com/zedshaw/mongrel2.git'
  homepage 'http://mongrel2.org/'
  sha1 '456561fe04f1c0ee4a996cfc9deadab8c57ee6dc'

  depends_on 'zeromq'

  def install
    # Build in serial. See:
    # https://github.com/mxcl/homebrew/issues/8719
    ENV.j1

    # Mongrel2 pulls from these ENV vars instead
    ENV['OPTFLAGS'] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV['OPTLIBS'] = ENV.ldflags

    system "make all"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
