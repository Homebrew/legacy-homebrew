require 'formula'

class Wordplay < Formula
  homepage 'http://hsvmovies.com/static_subpages/personal_orig/wordplay/index.html'
  url 'http://hsvmovies.com/static_subpages/personal_orig/wordplay/wordplay722.tar.Z'
  version '7.22'
  sha1 '629b4a876b6be966be7ddde7ccdfaa89fc226942'

  def patches
    # Fixes compiler warnings on Darwin
    # Point to words file in share
    { :p0 => [
      "https://trac.macports.org/export/101903/trunk/dports/games/wordplay/files/patch-wordplay.c"
    ]}
  end

  def install
    inreplace "wordplay.c", "@PREFIX@", prefix
    system "make", "CC=#{ENV.cc}"
    bin.install 'wordplay'
    (share/'wordplay').install 'words721.txt'
  end
end
