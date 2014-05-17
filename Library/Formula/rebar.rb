require "formula"

class Rebar < Formula
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.3.0.tar.gz"
  sha1 "4fc7eed4f3210c1547ba5ddfb5d3dc54a6422c37"

  head "https://github.com/rebar/rebar.git", :branch => "master"

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar"
  end

  test do
    system "rebar", "--version"
  end
end
