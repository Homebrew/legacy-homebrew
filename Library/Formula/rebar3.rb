class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/rebar/rebar3"
  url "https://github.com/rebar/rebar3/archive/3.0.0-beta.4.tar.gz"
  sha256 "be13a8b3b2421503785fe0a134413525238256ffd88c5f945249c5269936a65f"

  head "https://github.com/rebar/rebar3.git"

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
