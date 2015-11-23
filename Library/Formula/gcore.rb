class Gcore < Formula
  desc "Produce a snapshot (core dump) of a running process"
  homepage "http://osxbook.com/book/bonus/chapter8/core/"
  url "http://osxbook.com/book/bonus/chapter8/core/download/gcore-1.3.tar.gz"
  sha256 "6b58095c80189bb5848a4178f282102024bbd7b985f9543021a3bf1c1a36aa2a"

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
