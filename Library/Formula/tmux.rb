class Tmux < Formula
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.0/tmux-2.0.tar.gz"
  sha256 "795f4b4446b0ea968b9201c25e8c1ef8a6ade710ebca4657dd879c35916ad362"

  bottle do
    cellar :any
    sha256 "91a14274005416c9a20f64f149f732837b0503c0ddcfdc80f87c0576e99ee3fa" => :yosemite
    sha256 "d70b62ddf26d2113a108622643550dc50248c98188af27d7e2e76e415f43588d" => :mavericks
    sha256 "a1468fd6ac69c18c4773a65c11b2811525d542d911f6c6642e87c0e195f6c4c1" => :mountain_lion
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"

    system "make", "install"

    bash_completion.install "examples/bash_completion_tmux.sh" => "tmux"
    (share/"tmux").install "examples"
  end

  def caveats; <<-EOS.undent
    Example configurations have been installed to:
      #{share}/tmux/examples
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
