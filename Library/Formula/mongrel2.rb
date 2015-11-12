class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "http://mongrel2.org/"
  url "https://github.com/mongrel2/mongrel2/releases/download/v1.10.0/mongrel2-v1.10.0.tar.bz2"
  sha256 "f0ccca380a9725fd406a793d8f84f9c29876fe43cf06fc509b3296b5c16ba0aa"

  head "https://github.com/mongrel2/mongrel2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "a061480021232ebcf11af6bb2a6d8616e94fdf2e4eeaecf8a387b6f0f88f5720" => :el_capitan
    sha256 "03b2d837feeafecf97f30d2688dc0537187c0e6150f946ece5ff20d80939d655" => :yosemite
    sha256 "7cdef65628b457f03f3eb76fcf74276ffbc4b7d9fa0ff6d017fa43a8db98eeca" => :mavericks
  end

  depends_on "zeromq"

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.j1

    # Mongrel2 pulls from these ENV vars instead
    ENV["OPTFLAGS"] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV["OPTLIBS"] = "#{ENV.ldflags} -undefined dynamic_lookup"

    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"m2sh", "help"
  end
end
