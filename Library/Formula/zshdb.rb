class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/0.9/zshdb-0.09.tar.bz2"
  sha256 "3ad756485a5bfd014649f4ede15187d0cf070919d2ddb15b4ded61e8990e8d4f"

  bottle do
    sha256 "42267d6b8d74b9bf81f0b3f57b3fe1f2a724f35a3c9bda366d8167941c78ff59" => :yosemite
    sha256 "660523d688ea4ee07a8ab93d587a30eee65af059b2dffcd6b44ece9a8ca4e4cf" => :mavericks
    sha256 "c3c0946b33bad4787934c7837f5e987ff9b29743758501ddc617bd0278d9c8f0" => :mountain_lion
  end

  head do
    url "https://github.com/rocky/zshdb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "zsh"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zsh=#{HOMEBREW_PREFIX}/bin/zsh"
    system "make", "install"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/zshdb -c 'echo test'") do |stdin, stdout, _|
      stdin.write "exit\n"
      assert_match(/That's all, folks/, stdout.read)
    end
  end
end
