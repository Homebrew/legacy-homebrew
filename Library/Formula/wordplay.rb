class Wordplay < Formula
  desc "Anagram generator"
  homepage "http://hsvmovies.com/static_subpages/personal_orig/wordplay/index.html"
  url "http://hsvmovies.com/static_subpages/personal_orig/wordplay/wordplay722.tar.Z"
  version "7.22"
  sha256 "9436a8c801144ab32e38b1e168130ef43e7494f4b4939fcd510c7c5bf7f4eb6d"

  # Fixes compiler warnings on Darwin, via MacPorts.
  # Point to words file in share.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/5de9072/wordplay/patch-wordplay.c"
    sha256 "45d356c4908e0c69b9a7ac666c85f3de46a8a83aee028c8567eeea74d364ff89"
  end

  def install
    inreplace "wordplay.c", "@PREFIX@", prefix
    system "make", "CC=#{ENV.cc}"
    bin.install "wordplay"
    (share/"wordplay").install "words721.txt"
  end
end
