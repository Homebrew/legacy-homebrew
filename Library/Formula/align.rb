class Align < Formula
  desc "Text column alignment filter"
  homepage "https://www.cs.indiana.edu/~kinzler/align/"
  url "https://www.cs.indiana.edu/~kinzler/align/align-1.7.5.tgz"
  sha256 "cc692fb9dee0cc288757e708fc1a3b6b56ca1210ca181053a371cb11746969dd"

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
