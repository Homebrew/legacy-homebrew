class Surfraw < Formula
  desc "Shell Users' Revolutionary Front Rage Against the Web"
  homepage "https://surfraw.alioth.debian.org/"
  url "https://surfraw.alioth.debian.org/dist/surfraw-2.2.9.tar.gz"
  sha256 "aa97d9ac24ca4299be39fcde562b98ed556b3bf5ee9a1ae497e0ce040bbcc4bb"

  head do
    url "git://git.debian.org/surfraw/surfraw.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "cf0dd3b14c4e8034f0d0766fb09978eac0f19fa41730d72ed1422a67c0b0d0b3" => :yosemite
    sha256 "1291ba20882c2dc1fbb092782e943ab0b99ad3642fb73db207dadff1fc00c5fc" => :mavericks
    sha256 "30b885dc5908318868da2739f36834ce071bc7bff1a761fdc395afe82f75efa8" => :mountain_lion
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
    output = shell_output("#{bin}/surfraw -p duckduckgo homebrew")
    assert_equal "https://www.duckduckgo.com/lite/?q=homebrew\n", output
  end
end
