require "formula"

class Rebar < Formula
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.5.0.tar.gz"
  sha1 "2c52d3970f0ff10d5c0207ed1e05efbac1bb5a94"

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
