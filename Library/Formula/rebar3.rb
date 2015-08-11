class Rebar3 < Formula
  desc "rebar3: an erlang build tool"
  homepage "https://rebar3.org"

  devel do
    version "3.0.0-beta-1"

    url "https://github.com/rebar/rebar3/archive/beta-1.tar.gz"
    sha256 "94525dab9e3a50a126be60c86671f35a73dec960eac52b79b03003f692f69864"
    
    depends_on "erlang"
  end

  def install
    system "./bootstrap"
    bin.install "rebar3"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
