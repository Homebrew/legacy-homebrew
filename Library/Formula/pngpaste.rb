class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/0.2.1.tar.gz"
  sha256 "0fee49ae467b4db58da687089e1729a911f2c0d5c1583a4a0dcb59aba95da519"

  bottle do
    cellar :any
    sha1 "c1f92f560c8b41b2a76b0b697a836b6ebd583a69" => :yosemite
    sha1 "7456012df79ad5f465c9e87382fad9fdb7478e1e" => :mavericks
    sha1 "2da091bd8555367449efeb43a4c92044f26b6bbe" => :mountain_lion
  end

  def install
    system "make", "all"
    bin.install "pngpaste"
  end

  test do
    png = test_fixtures("test.png")
    system "osascript", "-e", "set the clipboard to POSIX file (\"#{png}\")"
    system bin/"pngpaste", "test.png"
    assert File.exist? "test.png"
  end
end
