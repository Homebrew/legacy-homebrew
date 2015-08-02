class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.23/libgit2-glib-0.23.0.tar.xz"
  sha256 "de12ce1d317fc1d8d32191fc121f5de86d557387f3782edd79fe7b8daa2c6345"

  bottle do
    sha256 "ed2f050469d1a0afa774c7e23156029c9bccf3f8f4e909fc1c9acedcffa35e3b" => :yosemite
    sha256 "49ee6711e69df6ffe5da282e1bb71279fa081d149d8f40513995601682d0f318" => :mavericks
    sha256 "b60ab7277a91ce2b5560d88044fa1d14b3ab388a9dfde1c27db5f7d71efd13d1" => :mountain_lion
  end

  head do
    url "https://github.com/GNOME/libgit2-glib.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libgit2" => "with-libssh2"
  depends_on "gobject-introspection"
  depends_on "glib"
  depends_on "vala" => :optional
  depends_on :python => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
    ]

    args << "--enable-python=no" if build.without? "python"
    args << "--enable-vala=no" if build.without? "vala"

    system "./autogen.sh", *args if build.head?
    system "./configure", *args if build.stable?
    system "make", "install"

    libexec.install "examples/.libs", "examples/clone", "examples/general", "examples/walk"
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
