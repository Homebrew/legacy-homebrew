class Redo < Formula
  desc "Implements djb's redo: an alternative to make(1)"
  homepage "https://github.com/apenwarr/redo"
  url "https://github.com/apenwarr/redo/archive/redo-0.11.tar.gz"
  sha256 "2d7743e1389b538e2bd06117779204058fc0fcc0e05fd5ae14791d7f3fc3bcfa"

  resource "docs" do
    url "https://github.com/apenwarr/redo.git", :branch => "man"
  end

  def install
    ENV["PREFIX"] = prefix
    system "./redo install"
    rm share/"doc/redo/README.md" # lets not have two copies
    man1.install resource("docs")
  end
end
