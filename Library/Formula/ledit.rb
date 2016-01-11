class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "http://pauillac.inria.fr/~ddr/ledit/"
  url "http://pauillac.inria.fr/~ddr/ledit/distrib/src/ledit-2.03.tgz"
  sha256 "ce08a8568c964009ccb0cbba45ae78b9a96c823f42a4fd61431a5b0c2c7a19ce"

  bottle do
    cellar :any
    sha256 "7ea1c26486320fc35269fa7bf2a1dd577f504a04ac3dca3278c568224661e99e" => :yosemite
    sha256 "a5d80c1e40de9d3d8ab06ca88e412fc3d5e105d99f2439ef62b063eed3efb4e5" => :mavericks
    sha256 "338e160cde4ece1c167ec07e8b202f599ba0267ac5c3b6ca896b569067cb2e20" => :mountain_lion
  end

  depends_on "ocaml"
  depends_on "camlp5"

  def install
    # like camlp5, this build fails if the jobs are parallelized
    ENV.deparallelize
    args = %W[BINDIR=#{bin} LIBDIR=#{lib} MANDIR=#{man}]
    system "make", *args
    system "make", "install", *args
  end

  test do
    history = testpath/"history"
    pipe_output("#{bin}/ledit -x -h #{history} bash", "exit\n", 0)
    assert history.exist?
    assert_equal "exit\n", history.read
  end
end
