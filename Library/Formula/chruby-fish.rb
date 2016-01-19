class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.7.2.tar.gz"
  sha256 "d64248ce9b80dfdb327b69f4db3cfd0901957a745fd8b3b0f8c2a31fd0840297"
  head "https://github.com/JeanMertz/chruby-fish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a18b22f5cd83f3528ae627721d63eb498bd67955a61817a5f86805920c16722a" => :el_capitan
    sha256 "e3ad932ac1564930f353dde84164b4e48a0e7aa058739059406d6875700b35a0" => :yosemite
    sha256 "a37383d26a65e3b131290556c7a3825ea8613770bf9d41df044050594d6cbff6" => :mavericks
  end

  depends_on "chruby" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
