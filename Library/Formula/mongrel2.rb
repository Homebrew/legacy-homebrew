class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "http://mongrel2.org/"
  url "https://github.com/mongrel2/mongrel2/releases/download/v1.10.0/mongrel2-v1.10.0.tar.bz2"
  sha256 "f0ccca380a9725fd406a793d8f84f9c29876fe43cf06fc509b3296b5c16ba0aa"

  head "https://github.com/mongrel2/mongrel2.git", :branch => "develop"

  bottle do
    cellar :any
    revision 1
    sha256 "90e7c30a269edc9ac6308b3dadb24565a4cd12a73b8b5f1a6e7c700b67c94cfa" => :el_capitan
    sha256 "d8e720c2b15edef337a4b064d5525bd9d82b55e8dccb9cd69152c9b4d3505517" => :yosemite
    sha256 "0412a19e55674114c6e2efb09d09cf8998a21b2aad03bfeed67bf9e7a946b694" => :mavericks
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
