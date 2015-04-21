require 'formula'

class Mongrel2 < Formula
  homepage 'http://mongrel2.org/'
  url 'https://github.com/zedshaw/mongrel2/releases/download/1.9.2/mongrel2-v1.9.2.tar.bz2'
  sha1 '1b44d8028bba7f427cfda3fc7bf6c4350d810a75'

  head 'https://github.com/zedshaw/mongrel2.git'

  depends_on 'zeromq'

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.j1

    # Mongrel2 pulls from these ENV vars instead
    ENV['OPTFLAGS'] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV['OPTLIBS'] = "#{ENV.ldflags} -undefined dynamic_lookup"

    system "make all"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
