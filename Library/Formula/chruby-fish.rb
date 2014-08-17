require "formula"

class ChrubyFish < Formula
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  head "https://github.com/JeanMertz/chruby-fish.git"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.6.0.tar.gz"
  sha1 "e8262283018137db89ba5031ec088a5df3df19d0"

  depends_on "chruby" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
