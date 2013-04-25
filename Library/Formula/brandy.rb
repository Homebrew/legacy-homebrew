require 'formula'

class Brandy < Formula
  homepage 'http://brandy.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/brandy/brandy/brandy-1.20/brandy-1.20pre5.tar.gz'
  version '1.20pre5'
  sha1 '47e1d123bb0745cffeb4e9fe706bc15bd70c92aa'

  depends_on 'sdl' => :build

  def patches
    # Added fixes for SDL support in OSX - http://www.witwenmacher.net/posts/2012-12-31-SDL-and-haskell.html
    [
      "http://pastebin.com/raw.php?i=u7iLMydS"
    ]
  end

  def install
    system "make CFLAGS=\"`sdl-config --cflags`\" LDFLAGS=\"`sdl-config --libs`\""
    bin.install 'brandy'
  end

  def test
    system "brandy"
  end
end
