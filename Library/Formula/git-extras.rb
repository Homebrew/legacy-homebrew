require "formula"

class GitExtras < Formula
  homepage "https://github.com/visionmedia/git-extras"
  url "https://github.com/visionmedia/git-extras/archive/v2.1.0.tar.gz"
  sha1 "0c08877905cf0255166771ffbf33f4724cdb22cd"

  head "https://github.com/visionmedia/git-extras.git", :branch => "master"

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
