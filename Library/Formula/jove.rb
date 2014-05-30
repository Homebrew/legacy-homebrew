require "formula"

class Jove < Formula
  homepage "http://directory.fsf.org/wiki/Jove"
  url "ftp://ftp.cs.toronto.edu/cs/ftp/pub/hugh/jove-dev/jove4.16.0.73.tgz"
  sha1 "fca6f33465b08eed5b90e24cfb67e61bc5249dcf"

  # Per MacPorts, avoid clash with libc getline
  patch :p0 do
    url "https://trac.macports.org/export/120116/trunk/dports/editors/jove/files/patch-getline.diff"
    sha1 "7d3632ddf46cece9d39c2e02b020259d8b2bf49e"
  end

  def install
    bin.mkpath
    man1.mkpath
    (lib/"jove").mkpath

    system "make", "install", "JOVEHOME=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    assert_match /There's nothing to recover./, %x{#{lib}/jove/recover}
  end
end
