class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, MagLev, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz"
  sha256 "3cc90846ca972d88b601789af2ad9ed0a496447a13cb986a3d74a4de062af37d"

  head "https://github.com/postmodern/ruby-install.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ruby-install"
  end
end
