class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "http://mupdf.com"
  url "http://mupdf.com/downloads/mupdf-1.7a-source.tar.gz"
  sha256 "8c035ffa011fc44f8a488f70da3e6e51889508bbf66fe6b90a63e0cfa6c17d1c"
  head "git://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any
    sha256 "1d41ff27c7c5cba201e6a0a87fc2fc623733dc6a1e7ba9f83d2e45a57915a36e" => :yosemite
    sha256 "ae9edbbd689cdb3987a5b996765f0020070333da51d827c4d23db8ccab067a73" => :mavericks
    sha256 "e972503d2358fb353e12918cfd9f40387fef4e9bd169aaf6814844b9232fe0fe" => :mountain_lion
  end

  depends_on :macos => :snow_leopard
  depends_on "openssl"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_match /Homebrew test/, shell_output("#{bin}/mudraw -F txt #{pdf}")
  end
end
