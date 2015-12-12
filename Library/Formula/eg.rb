class Eg < Formula
  desc "Expert Guide. Norton Guide Reader For GNU/Linux"
  homepage "https://github.com/davep/eg"
  url "https://github.com/davep/eg/archive/eg-v1.01.tar.gz"
  sha256 "bb7a2af37c8d5d07f785466692f21561257ff99106d2cb91db13ba2e946ff13b"
  head "https://github.com/davep/eg.git"

  bottle do
    cellar :any
    revision 1
    sha256 "e7d8afd59c28e7b0b1c41adddf33a81612beb702dafcc361b6419f8ceb557849" => :el_capitan
    sha256 "a76496f35cb02e8c6a71a821e408ddc7c771810a594c2f42359802f4e8833a2b" => :yosemite
    sha256 "2197c470b87aa65d756c2e574477bfaaf4ce755427d1fa7bb56d948292237eb6" => :mavericks
  end

  depends_on "s-lang"

  def install
    inreplace "eglib.c", "/usr/share/", "#{etc}/"
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}", "NGDIR=#{etc}/norton-guides"
  end

  test do
    # It will return a non-zero exit code when called with any option
    # except a filename, but will return success if the file doesn't
    # exist, without popping into the UI - we're exploiting this here.
    ENV["TERM"] = "xterm"
    system bin/"eg", "not_here.ng"
  end
end
