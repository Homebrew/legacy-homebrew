class Ledit < Formula
  homepage "http://pauillac.inria.fr/~ddr/ledit/"
  url "http://pauillac.inria.fr/~ddr/ledit/distrib/src/ledit-2.03.tgz"
  sha256 "ce08a8568c964009ccb0cbba45ae78b9a96c823f42a4fd61431a5b0c2c7a19ce"

  depends_on "objective-caml"
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
