class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.7.2.tar.gz"
  sha256 "d64248ce9b80dfdb327b69f4db3cfd0901957a745fd8b3b0f8c2a31fd0840297"
  head "https://github.com/JeanMertz/chruby-fish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c787e0ccf157727bd9013f056484b09bdd698ffbe5e417d9b1b3979844bfb0cf" => :el_capitan
    sha256 "88ab2a3351b19ae8d7f625de2faa39c261a3c43ba6c8940c61f172e937e62651" => :yosemite
    sha256 "d56f48b0a49d0c381bffc28ffe320019b89a87a708ec51f24218a0911104bd78" => :mavericks
  end

  depends_on "chruby" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
