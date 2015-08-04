class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, or MagLev"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz"
  sha256 "aa4448c2c356510cc7c2505961961a17bd3f3435842831e04c8516eb703afd19"

  head "https://github.com/postmodern/ruby-install.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
