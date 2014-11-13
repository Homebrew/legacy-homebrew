require 'formula'

class Orc < Formula
  homepage 'http://cgit.freedesktop.org/gstreamer/orc/'
  url 'http://gstreamer.freedesktop.org/src/orc/orc-0.4.22.tar.xz'
  sha1 'c50cf2f2a9a7e4ab400fd79f706e831ace1936bc'

  bottle do
    cellar :any
    sha1 "bec7e363073a890e5fecf672aff368d16135ba81" => :mavericks
    sha1 "7666ce536dfdd52724ff0e49109b40dfd58b2d6a" => :mountain_lion
    sha1 "ef6997d06ae94bd9e097a6ce33e882a3f965f383" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make install"
  end
end
