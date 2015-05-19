require "formula"

class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.4.7/fswatch-1.4.7.tar.gz"
  sha1 "bfc41da5a56ab810b28945506a0ad4198b13ffef"

  bottle do
    sha256 "1263ca1127a202ffd678803608d2620af5c43a4a8b3db1d987147df2b8a0cf7a" => :yosemite
    sha256 "ce054437060df774bd2a0d8587e5fd8230ecd738b3a06471c5c0cb4ec8713557" => :mavericks
    sha256 "76e5f7ee8a312b6f9b21e5e4f547586d2788b74c7467bcf5e4596300af3a4346" => :mountain_lion
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
