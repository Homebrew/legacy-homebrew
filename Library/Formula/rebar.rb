class Rebar < Formula
  desc "Erlang build tool"
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.6.1.tar.gz"
  sha256 "aed933d4e60c4f11e0771ccdb4434cccdb9a71cf8b1363d17aaf863988b3ff60"

  head "https://github.com/rebar/rebar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f78372d4343ce728ecc2bb555ffe37d3fc4b867331baa4ea23cc42ecc08e32d" => :el_capitan
    sha256 "addcbc45971028066f03c4fcf10b096fca8759677a03375d512d59b1cff78c35" => :yosemite
    sha256 "4ada78621f9e1b8fec08e63de736602f407c70af3de4b288a7edaf00a14c4b5b" => :mavericks
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
