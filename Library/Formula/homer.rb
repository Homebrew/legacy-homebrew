require "formula"

class Homer < Formula
  homepage "https://github.com/tubbo/homer"
  url "https://github.com/tubbo/homer/archive/0.0.2.tar.gz"
  sha1 "cfa34c73a144ea384dd22524add6295140654cf8"
  head "https://github.com/tubbo/homer.git"

  depends_on 'zsh'
  depends_on 'antigen'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    "Run `homer init` to set up your home dir."
  end

  test do
    system 'homer'
  end
end
