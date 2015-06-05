class Colortail < Formula
  desc "Like tail(1), but with various colors for specified output"
  homepage "https://github.com/joakim666/colortail"
  url "https://github.com/joakim666/colortail.git",
    :revision => "f44fce0dbfd6bd38cba03400db26a99b489505b5"
  version "0.3.4"

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
