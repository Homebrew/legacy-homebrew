require "formula"

class Signify < Formula
  homepage "http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man1/signify.1"
  head "https://github.com/jpouellet/signify-osx.git"
  url "https://github.com/jpouellet/signify-osx/archive/1.0.tar.gz"
  sha256 "12b05827683c78eb6883607ec2f63784bfc713832c02db37e5504eeb0f32b7a2"

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
