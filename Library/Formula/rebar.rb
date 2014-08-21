require "formula"

class Rebar < Formula
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.5.1.tar.gz"
  sha1 "cf8d3e33c21f09b826a52a681f5b729559a3280c"

  head "https://github.com/rebar/rebar.git", :branch => "master"

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar"
  end

  test do
    system bin/"rebar", "--version"
  end
end
