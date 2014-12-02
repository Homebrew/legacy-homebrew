require "formula"

class GitExtras < Formula
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/2.2.0.tar.gz"
  sha1 "cb3df2bc8953fdae7b73c3d309e79ee5316bb90d"

  head "https://github.com/tj/git-extras.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "c8c8a635d8555679422c6d7a06e32e3c08b4e32c" => :mavericks
    sha1 "cb24ad03c24209431b4242f5cfc863046fcfc163" => :mountain_lion
    sha1 "f1bdf0558b495a466eba8be250c6fda94a94c1fc" => :lion
  end

  # Don't take +x off these files
  skip_clean "bin"

  def install
    inreplace "Makefile", %r|\$\(DESTDIR\)(?=/etc/bash_completion\.d)|, "$(DESTDIR)$(PREFIX)"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
