require "formula"

class Mongroup < Formula
  homepage "https://github.com/jgallen23/mongroup"
  url "https://github.com/jgallen23/mongroup/archive/0.4.1.tar.gz"
  sha1 "fa0f7b1e43ff3963f4851f378478a86a362dd345"

  bottle do
    cellar :any
    sha1 "362393e9e2409030379af478625bc1eac846acef" => :mavericks
    sha1 "a813a9be26dd962ab7dd1a2e4f8b53adcb082b25" => :mountain_lion
    sha1 "988c86f7ef36e75354dc676028d5ed560ecd3ae5" => :lion
  end

  depends_on "mon"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mongroup", "-V"
  end
end
