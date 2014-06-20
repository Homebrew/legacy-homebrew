require 'formula'

class Ddate < Formula
  homepage "https://github.com/bo0ts/ddate"
  url "https://github.com/bo0ts/ddate/archive/v0.2.2.tar.gz"
  sha1 "fafb5867c93d7328a1c5e8a0b9726f98362c0c09"

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install "ddate"
    man1.install "ddate.1"
  end
end
