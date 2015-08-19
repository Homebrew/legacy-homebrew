class Rebar < Formula
  desc "Erlang build tool"
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.6.0.tar.gz"
  sha256 "9f30ea5ab9da8638273cb55b49780e58fed1f4aa8623b835bcdd983bb451f7a7"

  head "https://github.com/rebar/rebar.git"

  bottle do
    cellar :any
    sha256 "e2839ba7bfd37e0fdb4f91ed07990f058252b04c403758852c5ab9269ba7b452" => :yosemite
    sha256 "c6fce9414e95e7264570cbf5c1962d7b7a6c5d8d0342732ab83108ca9921cab0" => :mavericks
    sha256 "4cdc93fcbd623ecd607b6eb7cbccbe74512768d869b66360e54cf028b866dfa0" => :mountain_lion
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar"
  end

  test do
    system bin/"rebar", "--version"
  end
end
