class Surfraw < Formula
  desc "Shell Users' Revolutionary Front Rage Against the Web"
  homepage "http://surfraw.alioth.debian.org/"
  head "git://git.debian.org/surfraw/surfraw.git"
  url "http://surfraw.alioth.debian.org/dist/surfraw-2.2.9.tar.gz"
  sha1 "70bbba44ffc3b1bf7c7c4e0e9f0bdd656698a1c0"

  bottle do
    sha1 "6c592c99adf6c1a0bb4993a36e4392bce6e24eaa" => :yosemite
    sha1 "8ca477ffd5f157aa40b258d66e2536691d769921" => :mavericks
    sha1 "b17ead2b3f8030e659d0af4b44332f76397607f5" => :mountain_lion
  end

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
