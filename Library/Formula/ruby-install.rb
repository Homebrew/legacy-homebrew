class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, MagLev, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz"
  sha256 "3cc90846ca972d88b601789af2ad9ed0a496447a13cb986a3d74a4de062af37d"

  head "https://github.com/postmodern/ruby-install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38703ce6849bf87c8a67e0e1b9f093f0cba1b5d9cceb88b44fb9949ff4fafbe4" => :el_capitan
    sha256 "c2e7fd7648f01527d596f416405418bdbee463604f3013c1cd860b4e2b0543c2" => :yosemite
    sha256 "ec0f19e5ab2fb76c1449e22a412505d2061180c9bb4d89896f73316dd15a4926" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
