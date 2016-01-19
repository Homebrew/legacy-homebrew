class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.7.1.tar.gz"
  sha256 "bb2159c37ec77eae76314630c0feb48bde5c4ce1fefa8f1460a7c8ffaacf7bc2"
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
