require "formula"

class Gcore < Formula
  homepage "http://osxbook.com/book/bonus/chapter8/core/"
  url "http://osxbook.com/book/bonus/chapter8/core/download/gcore-1.3.tar.gz"
  sha1 "92c0bf04577f86b05fb7bede7aa196d257f8aad2"

  bottle do
    cellar :any
    sha1 "370c2f33ce79d1dbd0715b57d6e5fa8fd5338fbe" => :mavericks
    sha1 "6b94b3961f147490fac3f259e8158d0d0ef9feb3" => :mountain_lion
    sha1 "746794e1c9f6114185be7afc018ae8fda2e13fcd" => :lion
  end

  def install
    ENV.universal_binary
    system "make"
    bin.install "gcore"
  end
end
