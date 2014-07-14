require "formula"

class Rebar < Formula
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.4.0.tar.gz"
  sha1 "e694cb6de0f4046166226f096a8cd1e52cb42555"

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
