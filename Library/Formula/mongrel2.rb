require 'formula'

class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage 'http://mongrel2.org/'
  url 'https://github.com/zedshaw/mongrel2/releases/download/1.9.2/mongrel2-v1.9.2.tar.bz2'
  sha1 '1b44d8028bba7f427cfda3fc7bf6c4350d810a75'
  revision 1

  head 'https://github.com/zedshaw/mongrel2.git'

  bottle do
    cellar :any
    sha256 "b25a776905c9e439d63a190bdcb5a6fedf689dc70e22ae2fd371d7ea61dbb6d4" => :yosemite
    sha256 "a2d42a99ccf6cbf342f558e2ccebf54c010a17014ce8ea2bfde1b4678f9bd98d" => :mavericks
    sha256 "23a8bf5473815f626590e58124a5a57cf73ca1e05e846dfd28ab160ac4326e18" => :mountain_lion
  end

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
