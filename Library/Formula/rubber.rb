class Rubber < Formula
  desc "Automated building of LaTeX documents"
  homepage "https://launchpad.net/rubber/"
  url "https://launchpad.net/rubber/trunk/1.2/+download/rubber-1.2.tar.gz"
  sha256 "776d859fb75f952cac37bd1b60833840e3a6cdd8d6d01f214b379d3c76618e95"
  version "20150624-1.2"

  bottle do
    sha256 "928de907e2ff3961c72ff71380fd7db0fc072ae526dc77068718b618ce80f5e6" => :yosemite
    sha256 "33e93b904403bccb9a139ac963cbec128d3a23422e3bb69bd31bbe03191a464a" => :mavericks
    sha256 "e7480ca80262718ac62b26c3573c1b7e3091a2ed1766d7f33967f2620911fbc4" => :mountain_lion
  end

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

    bin.env_script_all_files(
      libexec/"bin",
      :PYTHONPATH => lib/"python2.7/site-packages"
    )
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rubber --version")
  end
end
