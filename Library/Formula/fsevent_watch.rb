class FseventWatch < Formula
  desc "OS X FSEvents client"
  homepage "https://github.com/proger/fsevent_watch"
  url "https://github.com/proger/fsevent_watch/archive/v0.1.tar.gz"
  sha256 "260979f856a61230e03ca1f498c590dd739fd51aba9fa36b55e9cae776dcffe3"

  head "https://github.com/proger/fsevent_watch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9ff549a7f9f5b31ffe923beddc1a8ab123c11e76bb833fb882785342d119768" => :el_capitan
    sha256 "085b1a0cdc155ec6833d782ebd86e8109f6a4529ff3719f3605fce5779925456" => :yosemite
    sha256 "900dff7d67ce9b31c9e1a3884315d8ed407cbd89358aed68fda283f7782ff2c6" => :mavericks
    sha256 "fb7163be62f68a7eeea7b67da63d5313dc56c88c28f785f4276308ee14d2bdd1" => :mountain_lion
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}", "CFLAGS=-DCLI_VERSION=\\\"#{version}\\\""
  end

  test do
    system "fsevent_watch", "--version"
  end
end
