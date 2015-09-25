require "formula"

class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "http://mongrel2.org/"
  url "https://github.com/mongrel2/mongrel2/releases/download/v1.9.3/mongrel2-v1.9.3.tar.bz2"
  sha256 "40ee0e804053f812cc36906464289ea656a4fc53b4a82d49796cafbe37f97425"

  head "https://github.com/mongrel2/mongrel2.git"

  bottle do
    cellar :any
    sha256 "7ec33fab8c9e95f1d83fdd72b3209773d76dd7ef08134214a7e51f1b20969f03" => :yosemite
    sha256 "f8b15e5f50d29e955763111079b6715c6cbd8531ef6b9aa13f514a9c774e5f43" => :mavericks
    sha256 "2bdf0a2207bc8aac4c02638cad6febadcef6f473bc324f15d2f31c013b3b7707" => :mountain_lion
  end

  depends_on "zeromq"

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.j1

    # Mongrel2 pulls from these ENV vars instead
    ENV["OPTFLAGS"] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV["OPTLIBS"] = "#{ENV.ldflags} -undefined dynamic_lookup"

    system "make all"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
