class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://downloads.sourceforge.net/project/vifm/vifm/vifm-0.8.1.tar.bz2"
  mirror "https://github.com/vifm/vifm/releases/download/v0.8.1/vifm-0.8.1.tar.bz2"
  sha256 "9918ac96290f9bb2da0fdbd6e579af19de32d9eca41d0ceb5e2cb7cf08ebc379"

  bottle do
    revision 1
    sha256 "57d2224f685ad01c2cded9a3840c6999a75e3544111c501822412ac6bac9f460" => :el_capitan
    sha256 "d875cfb97b83552d78ff3ed9d1c2ec8faa35ed2b4bd27dabbeb48eca7af820f0" => :yosemite
    sha256 "032ed7e7c2256a7e352322b65e68fd220ce35d59ea9a558d2112df86275fbe45" => :mavericks
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
