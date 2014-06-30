require 'formula'

class Mongrel2 < Formula
  homepage 'http://mongrel2.org/'
  url 'https://github.com/zedshaw/mongrel2/archive/v1.8.1.tar.gz'
  sha1 '11230cb59aa4834e017023c8f9b6519831d91767'

  head 'https://github.com/zedshaw/mongrel2.git'

  depends_on 'zeromq'

  # allow mongrel2 to build against libzmq 4
  patch do
    url "https://gist.githubusercontent.com/minrk/7632116/raw/44d0ed09ecfc68a9f9d6a940c6367f703cd55c46/0001-add-zmq_compat-check-for-libzmq-4.patch"
    sha1 "f4279ced05362b916c1abf874c69781a66f55abf"
  end

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.j1

    # Mongrel2 pulls from these ENV vars instead
    ENV['OPTFLAGS'] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV['OPTLIBS'] = ENV.ldflags

    system "make all"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
