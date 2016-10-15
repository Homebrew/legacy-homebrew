require "formula"

class Envchain < Formula
  homepage "https://github.com/sorah/envchain"
  url "https://github.com/sorah/envchain/archive/v0.1.0.tar.gz"
  sha1 "184d77032de985538a630e4ca4d17ed9d2e71566"

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end
end
