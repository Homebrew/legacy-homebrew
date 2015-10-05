class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.6.0.tar.gz"
  sha256 "9549a195bf2ffc2d613124f891253c85a1e17066fa100f5bf423537dffd7e6d8"
  head "https://github.com/JeanMertz/chruby-fish.git"

  depends_on "chruby" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
