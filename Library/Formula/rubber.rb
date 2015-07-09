class Rubber < Formula
  desc "Automated building of LaTeX documents"
  homepage "https://launchpad.net/rubber/"
  url "https://launchpad.net/rubber/trunk/1.2/+download/rubber-1.2.tar.gz"
  sha256 "776d859fb75f952cac37bd1b60833840e3a6cdd8d6d01f214b379d3c76618e95"
  version "20150624-1.2"

  head "lp:rubber", :using => :bzr

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    # `install` requires but does not make the docs
    system "make"
    system "make", "install"

    # Don't need to peg to a specific Python version
    inreplace Dir["#{bin}/*"], %r{^#!.*\/python.*$}, "#!/usr/bin/env python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rubber --version")
  end
end
