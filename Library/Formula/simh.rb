class Simh < Formula
  desc "Portable, multi-system simulator"
  homepage "http://simh.trailing-edge.com/"
  url "http://simh.trailing-edge.com/sources/simhv39-0.zip"
  sha256 "e49b259b66ad6311ca9066dee3d3693cd915106a6938a52ed685cdbada8eda3b"
  version "3.9-0"

  head "https://github.com/simh/simh.git"

  # After 3.9-0 the project moves to https://github.com/simh/simh
  # It doesn't actually fail, but the makefile queries llvm-gcc -v --help a lot
  # to determine what flags to throw.  It is simply not designed for clang.
  # Remove at the next revision that will support clang (see github site).
  fails_with :clang do
    build 421
    cause "The program is closely tied to gcc & llvm-gcc in this revision."
  end

  def install
    ENV.deparallelize unless build.head?
    inreplace "makefile", "GCC = gcc", "GCC = #{ENV.cc}"
    inreplace "makefile", "CFLAGS_O = -O2", "CFLAGS_O = #{ENV.cflags}"
    system "make", "USE_NETWORK=1", "all"
    bin.install Dir["BIN/*"]
    Dir["**/*.txt"].each do |f|
      (doc/File.dirname(f)).install f
    end
    (share/"simh/vax").install Dir["VAX/*.{bin,exe}"]
  end

  test do
    assert_match(/Goodbye/, pipe_output("#{bin}/altair", "exit\n", 0))
  end
end
