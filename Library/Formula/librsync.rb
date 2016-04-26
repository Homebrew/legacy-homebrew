class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "http://librsync.sourcefrog.net/"
  url "https://github.com/librsync/librsync/archive/v2.0.0.tar.gz"
  sha256 "b5c4dd114289832039397789e42d4ff0d1108ada89ce74f1999398593fae2169"
  revision 1

  bottle do
    sha256 "f9b52eb45dd0cc166e5d31e3a90cd02bd99c619a5893dd3c8129757528e410cb" => :el_capitan
    sha256 "31709e2fe6f0480a825209e7aa13602f768db43be57477738e2f7f7150213869" => :yosemite
    sha256 "bc7ada34fb6aae7fcb9a303a3daeda5861ab11e0a966425aaed2e549fd88e6b9" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    ENV.universal_binary if build.universal?

    # https://github.com/librsync/librsync/commit/1765ad0d416
    # https://github.com/librsync/librsync/issues/50
    # Safe to remove when the next stable release is cut.
    inreplace "src/search.c", "if (l == r) {", "if ((l == r) && (l <= bucket->r)) {"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end
