class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "http://mongrel2.org/"
  head "https://github.com/mongrel2/mongrel2.git", :branch => "develop"

  stable do
    url "https://github.com/mongrel2/mongrel2/releases/download/v1.11.0/mongrel2-v1.11.0.tar.bz2"
    sha256 "917f2ce07c0908cae63ac03f3039815839355d46568581902377ba7e41257bed"

    # ensure unit tests work on 1.11.0. remove after next release
    patch do
      url "https://github.com/mongrel2/mongrel2/commit/7cb8532e2ecc341d77885764b372a363fbc72eff.patch"
      sha256 "b1861a49c7edff66cfd6bd898c8ce2e0ed7a5e9ecc454fdab337fb70af2346cd"
    end
  end

  bottle do
    cellar :any
    sha256 "7a6880cbc814b084a3ac91e379b7a720438951e31a18119c232f976fded229c3" => :el_capitan
    sha256 "0b2926fe3d79ab934e95f0e5c067e8bb23b6900b99255482defee9388a0dee07" => :yosemite
    sha256 "dd07092a2384c243fcd8c54ed67f2a728f3da698276540fc1c9b201eb3c5cbbb" => :mavericks
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
