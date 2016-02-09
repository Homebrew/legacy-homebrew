class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  stable do
    url "https://github.com/tmux/tmux/releases/download/2.1/tmux-2.1.tar.gz"
    sha256 "31564e7bf4bcef2defb3cb34b9e596bd43a3937cad9e5438701a81a5a9af6176"

    patch do
      # This fixes the Tmux 2.1 update that broke the ability to use select-pane [-LDUR]
      # to switch panes when in a maximized pane https://github.com/tmux/tmux/issues/150#issuecomment-149466158
      url "https://github.com/tmux/tmux/commit/a05c27a7e1c4d43709817d6746a510f16c960b4b.diff"
      sha256 "2a60a63f0477f2e3056d9f76207d4ed905de8a9ce0645de6c29cf3f445bace12"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "671875e204c40cfdd202ab734bce872c2089eb69d6f8ba9e0e42e08f76d534a1" => :el_capitan
    sha256 "bf0b9f1d072017cba16945d6b1777edafe6f5b737d3aa43657a3f041af6503ae" => :yosemite
    sha256 "0f8cad0fd30933e9ce863a7db647ca197535f79f623ff19b054fb4b03b1c0613" => :mavericks
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

    if build.head?
      pkgshare.install "example_tmux.conf"
    else
      bash_completion.install "examples/bash_completion_tmux.sh" => "tmux"
      pkgshare.install "examples"
    end
  end

  def caveats; <<-EOS.undent
    Example configuration has been installed to:
      #{opt_pkgshare}
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
