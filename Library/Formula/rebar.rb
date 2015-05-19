require "formula"

class Rebar < Formula
  desc "Erlang build tool"
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.5.1.tar.gz"
  sha1 "cf8d3e33c21f09b826a52a681f5b729559a3280c"

  head "https://github.com/rebar/rebar.git"

  bottle do
    cellar :any
    sha1 "e2908a79a0819ae121f2ecad281474bae417bfe4" => :mavericks
    sha1 "fe9177f8b1b5d165de672fb27e4906ae5f9a9f64" => :mountain_lion
    sha1 "22db3c6c0b933ad003f9495fe2528fe5bb8f73fa" => :lion
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
