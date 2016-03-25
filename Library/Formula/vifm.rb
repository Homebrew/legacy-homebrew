class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://downloads.sourceforge.net/project/vifm/vifm/vifm-0.8.1a.tar.bz2"
  mirror "https://github.com/vifm/vifm/releases/download/v0.8.1a/vifm-0.8.1a.tar.bz2"
  sha256 "974fb2aa5e32d2c729ceff678c595070c701bd30a6ccc5cb6ca64807a9dd4422"

  bottle do
    sha256 "46ad2f98c56e9306c00540ead159cbc70f02e4a7947e9f3f80f2408a01752f01" => :el_capitan
    sha256 "140c708112af6fc1c4f7c740abdca3af0e3fc12a8205cfa428800f7794541b6f" => :yosemite
    sha256 "ba80ce8c6d4762404cfd8f1595823ad1d7e347447dbbe50c1d73ad75a10efdcf" => :mavericks
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
