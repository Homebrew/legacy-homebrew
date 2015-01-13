class Surfraw < Formula
  homepage "http://surfraw.alioth.debian.org/"
  head "git://git.debian.org/surfraw/surfraw.git"
  url "http://surfraw.alioth.debian.org/dist/surfraw-2.2.9.tar.gz"
  sha1 "70bbba44ffc3b1bf7c7c4e0e9f0bdd656698a1c0"

  def install
    system "./prebuild" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-graphical-browser=open"
    system "make"
    ENV.j1
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/surfraw -p google -results=1 homebrew")
    assert_equal "http://www.google.com/search?q=homebrew&num=1\n", output
  end
end
