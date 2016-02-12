class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://downloads.sourceforge.net/project/vifm/vifm/vifm-0.8.1a.tar.bz2"
  mirror "https://github.com/vifm/vifm/releases/download/v0.8.1a/vifm-0.8.1a.tar.bz2"
  sha256 "974fb2aa5e32d2c729ceff678c595070c701bd30a6ccc5cb6ca64807a9dd4422"

  bottle do
    sha256 "88710cadc4638de655ad4e6522261a3af830c12284456f8915131dbb7b26f756" => :el_capitan
    sha256 "51f32cb0303c43edb4f7c903b3b5c5a43caf5dcd06e411984959cbdfee4f1954" => :yosemite
    sha256 "ad8ed5f68b7f5a73794e93c7402dee41178384b9c43ebe05e85d73fb99617123" => :mavericks
  end

  head do
    url "https://github.com/vifm/vifm.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /^Version: #{Regexp.escape(version)}/,
      shell_output("#{bin}/vifm --version")
  end
end
