class Vimpc < Formula
  desc "Ncurses based mpd client with vi like key bindings"
  homepage "https://sourceforge.net/projects/vimpc/"
  url "https://downloads.sourceforge.net/project/vimpc/Release%200.09.1/vimpc-0.09.1.tar.gz"
  sha256 "082fa9974e01bf563335ebf950b2f9bc129c0d05c0c15499f7827e8418306031"

  bottle do
    sha256 "6ea8c2cde12065c4a75c2e1f1cedfac5e4f4e9292207e5bb99f28d2230f155fb" => :el_capitan
    sha256 "ec6e37e02232ed228395fbbcebff5ec7a7a6b9ab9b057bb72731d57e73b3fbe8" => :yosemite
    sha256 "cf6f37c33dc0c524ca7ecb32b55d8b1e6a3c7eb024cb87e48cd3da4e1affa4bc" => :mavericks
  end

  head do
    url "https://github.com/boysetsfrog/vimpc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build unless MacOS.version >= :mavericks
  depends_on "taglib"
  depends_on "libmpdclient"
  depends_on "pcre"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/vimpc", "-v"
  end
end
