class Vis < Formula
  desc "Modern, legacy free, simple yet efficient vim-like editor"
  homepage "http://www.brain-dump.org/projects/vis"
  url "http://www.brain-dump.org/projects/vis/vis-0.2.tar.gz"
  sha256 "3e5b81d760849c56ee378421e9ba0f653c641bf78e7594f71d85357be99a752d"
  head "https://github.com/martanne/vis.git"

  keg_only "Shadows OS X' `vis` command"

  depends_on "libtermkey"
  depends_on "lua"
  depends_on "lpeg" => :lua

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/vis"
  end
end
