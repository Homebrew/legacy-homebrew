class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "http://mongrel2.org/"
  url "https://github.com/mongrel2/mongrel2/releases/download/v1.11.0/mongrel2-v1.11.0.tar.bz2"
  sha256 "917f2ce07c0908cae63ac03f3039815839355d46568581902377ba7e41257bed"

  head "https://github.com/mongrel2/mongrel2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "a061480021232ebcf11af6bb2a6d8616e94fdf2e4eeaecf8a387b6f0f88f5720" => :el_capitan
    sha256 "03b2d837feeafecf97f30d2688dc0537187c0e6150f946ece5ff20d80939d655" => :yosemite
    sha256 "7cdef65628b457f03f3eb76fcf74276ffbc4b7d9fa0ff6d017fa43a8db98eeca" => :mavericks
  end

  stable do
    # ensure unit tests work on 1.11.0. remove after next release
    patch do
      url "https://github.com/mongrel2/mongrel2/commit/7cb8532e2ecc341d77885764b372a363fbc72eff.patch"
      sha256 "b1861a49c7edff66cfd6bd898c8ce2e0ed7a5e9ecc454fdab337fb70af2346cd"
    end
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
