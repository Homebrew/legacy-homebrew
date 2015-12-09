class Lorem < Formula
  desc "Lorem Ipsum generator"
  homepage "https://code.google.com/p/lorem/"
  url "https://lorem.googlecode.com/svn-history/r4/trunk/lorem", :using => :curl
  version "0.6.1"
  sha256 "fa2db7c3db356d76ed6dd5244a76d9b6e0d261d89d5efa646c8fe2924be5abcf"

  bottle :unneeded

  def install
    inreplace "lorem", "!/usr/bin/python", "!/usr/bin/env python"
    bin.install "lorem"
  end

  test do
    assert_equal "lorem ipsum", shell_output("#{bin}/lorem -n 2").strip
  end
end
