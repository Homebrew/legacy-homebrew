require 'formula'

class Wiggle < Formula
  homepage "http://neil.brown.name/blog/20100324064620"
  url "http://neil.brown.name/wiggle/wiggle-1.0.tar.gz"
  sha1 "07fa4450c658d3f24d2e529b7fc4d883b5ba2e51"

  # All three patches are upstream commits
  patch do
    url "https://github.com/neilbrown/wiggle/commit/16bb4be1c93be24917669d63ab68dd7d77597b63.patch"
    sha1 "05c372272ed4817c92a17f2b46b5888189913259"
  end

  patch do
    url "https://github.com/neilbrown/wiggle/commit/e010f2ffa78b0e50eff5a9e664f9de27bb790035.patch"
    sha1 "d156b817582b36d9bc96a718b9e3eee5d82b8eb9"
  end

  patch do
    url "https://github.com/neilbrown/wiggle/commit/351535d3489f4583a49891726616375e249ab1f3.patch"
    sha1 "32385bdf365440f115d8d830f7e4b5a4710d230f"
  end

  def install
    system "make", "OptDbg=#{ENV.cflags}", "wiggle", "wiggle.man", "test"
    bin.install "wiggle"
    man1.install "wiggle.1"
  end
end
