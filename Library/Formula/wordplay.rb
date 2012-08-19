require 'formula'

class Wordplay < Formula
  homepage 'http://hsvmovies.com/static_subpages/personal_orig/wordplay/index.html'
  url 'http://hsvmovies.com/static_subpages/personal_orig/wordplay/wordplay722.tar.Z'
  sha1 '629b4a876b6be966be7ddde7ccdfaa89fc226942'

  def patches
    # Fixes compiler warnings on Darwin
    { :p0 => "https://raw.github.com/gist/3396973/b7d4b268e2dd047df0ec9448ecf286494e23049d/wordplay-darwin.c" }
  end

  def install
    system "make"
    system "install -d -m 755 #{share}/wordplay"
    system "install -d -m 755 #{bin}"
    system "install -m 755 wordplay #{bin}/wordplay"
    system "install -m 644 readme #{share}/wordplay/readme"
    system "install -m 644 words721.txt #{share}/wordplay/words721.txt"
  end

end
