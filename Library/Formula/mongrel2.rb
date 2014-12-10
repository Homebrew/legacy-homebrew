require 'formula'

class Mongrel2 < Formula
  homepage 'http://mongrel2.org/'
  url 'https://github.com/zedshaw/mongrel2/releases/download/v1.9.1/mongrel2-v1.9.1.tar.gz'
  sha1 'c06b71e23da9537b401e2743c9129a8d16ef6911'

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
