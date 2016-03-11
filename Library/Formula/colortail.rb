class Colortail < Formula
  desc "Like tail(1), but with various colors for specified output"
  homepage "https://github.com/joakim666/colortail"
  url "https://github.com/joakim666/colortail.git",
    :revision => "f44fce0dbfd6bd38cba03400db26a99b489505b5"
  version "0.3.4"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0c8c9af739ce911c0d09eaee26b615444c17f48de27c680cbaf27739e45d8f5" => :el_capitan
    sha256 "1be1c0067a5621f5edcabf64ec06a775d334924e4ea01bccd1c42830f6c9d0c6" => :yosemite
    sha256 "8570fbda1625d70eac83d0e53a1d32d0cd7b32f9fb0b8dea38d32a3228dc6688" => :mavericks
    sha256 "cba08e3d00b530eca42cd2d95dc0c3ed9419f199e7f26edc068b5b1074c3fe51" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  # Upstream PR to fix the build on ML
  patch do
    url "https://github.com/joakim666/colortail/pull/12.diff"
    sha256 "2bb9963f6fc586c8faff3b51a48896cf09c68c4229c39c6ae978a59cb58d0fd7"
  end

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello\nWorld!\n"
    assert_match(/World!/, shell_output("#{bin}/colortail -n 1 test.txt"))
  end
end
