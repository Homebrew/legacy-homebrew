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

    patch do
      # This fixes the Tmux 2.1 update that breaks "tmux killw\; detach"
      # https://github.com/tmux/tmux/issues/153#issuecomment-150184957
      url "https://github.com/tmux/tmux/commit/3ebcf25149d75977ea97e9d4f786e0508d1a0d5e.diff"
      sha256 "65a8bc0b2f6a8b41ad27605fd99419fff36314499969adc9d17dd3940a173508"
    end
  end

  bottle do
    cellar :any
    revision 2
    sha256 "815920cd38a8102360f7d667271d9c724f41087dd79be433db29259390ef8011" => :el_capitan
    sha256 "93e2156c3c7e1c9f3f4b86dd84617e7519e9bee630f1e8769e00a91aa341d274" => :yosemite
    sha256 "03c4ca001f72a1623393c0ec9406dfd82b7e449d745762a6e761da6a95d0fbd9" => :mavericks
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

    man1.install "tmux.1"
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
