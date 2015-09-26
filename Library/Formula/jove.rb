class Jove < Formula
  desc "Emacs-style editor with vi-like memory, CPU, and size requirements"
  homepage "http://directory.fsf.org/wiki/Jove"
  url "ftp://ftp.cs.toronto.edu/cs/ftp/pub/hugh/jove-dev/jove4.16.0.73.tgz"
  sha256 "9c9e202607f5972c382098d10b63c815ac01e578f432626c982e6aa65000c630"

  # Per MacPorts, avoid clash with libc getline
  patch :p0 do
    url "https://trac.macports.org/export/120116/trunk/dports/editors/jove/files/patch-getline.diff"
    sha256 "96e557370d6e8924cc73bda8dbe65e54f4cc902785ffcf0056d8925bb4e77bf6"
  end

  def install
    bin.mkpath
    man1.mkpath
    (lib/"jove").mkpath

    system "make", "install", "JOVEHOME=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    assert_match /There's nothing to recover./, `#{lib}/jove/recover`
  end
end
