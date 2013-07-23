require 'formula'

class Mongrel2 < Formula
  homepage 'http://mongrel2.org/'
  url 'https://github.com/zedshaw/mongrel2/archive/v1.8.1.tar.gz'
  sha1 '11230cb59aa4834e017023c8f9b6519831d91767'

  head 'https://github.com/zedshaw/mongrel2.git'

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
