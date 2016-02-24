class Align < Formula
  desc "Text column alignment filter"
  homepage "https://www.cs.indiana.edu/~kinzler/align/"
  url "https://www.cs.indiana.edu/~kinzler/align/align-1.7.4.tgz"
  sha256 "4775cc92bd7d5d991b32ff360ab74cfdede06c211def2227d092a5a0108c1f03"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "41bd26049033526b97ba0f105b167557fa235528ae219e910fad5e100b7da739" => :el_capitan
    sha256 "19858dfce4d7c21a5cd013200a5f725a54c924227f08d5f19b5f2a9a0c44054a" => :yosemite
    sha256 "783440c9aaca24183a35be475b268d82dd33acccaef86f3e4eb8b2ca8e1ed1d1" => :mavericks
  end

  conflicts_with "speech-tools", :because => "both install `align` binaries"

  def install
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    assert_equal " 1  1\n12 12\n", pipe_output(bin/"align", "1 1\n12 12\n")
  end
end
