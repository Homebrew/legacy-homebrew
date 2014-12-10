require "formula"

class Tup < Formula
  homepage "http://gittup.org/tup/"
  url "https://github.com/gittup/tup/archive/v0.7.3.tar.gz"
  sha1 "e817ab1888b8aab7f784efa7fb90e91c216fae8d"
  head "https://github.com/gittup/tup.git"

  bottle do
    cellar :any
    sha1 "5c27fa734b85b0f170bc0ecc6fd5678160f2e5c9" => :mavericks
    sha1 "d6b68541413f647c5902e8256b4e7e454a2b176c" => :mountain_lion
    sha1 "938305bff64f99d93e093919e0c808f5786de913" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  # Fixes the renaming of functions on OS X 10.10
  # https://github.com/gittup/tup/issues/204
  if MacOS.version >= :yosemite
    patch do
      url "https://github.com/gittup/tup/pull/205.diff"
      sha1 "eebe8293b18096361130d0a97e0f10c524a716b3"
    end
  end

  def install
    ENV["TUP_LABEL"] = version
    system "./build.sh"
    bin.install "build/tup"
    man1.install "tup.1"
  end

  test do
    system "#{bin}/tup", "-v"
  end
end
