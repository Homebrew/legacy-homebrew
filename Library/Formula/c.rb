class C < Formula
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/v0.06.zip"
  version "0.06"
  sha1 "2e13cf0e48764e28d8811686f63505603ba76b18"

  depends_on "gnu-sed"

  def install
    inreplace "c", "sed", "gsed"
    bin.install "c"
  end
  
  test do
    system "c --help"
  end
end
