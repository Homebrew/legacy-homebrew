class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.23/libgit2-glib-0.23.6.tar.xz"
  sha256 "5c8d6b5cb81ab64b96cb0c52ef37463b6d8998a40ce77a08eda9db66fb781144"

  bottle do
    sha256 "9879907a8960a0b92143308f51835cd06ceecddcb7d6882928bd8c55fd86120b" => :el_capitan
    sha256 "878b8264d9ee4a13d9f8433e6c548e9e8d7e2472d49a41b7258e6e071f28e3a8" => :yosemite
    sha256 "b00b6989a1544380a206a250824dec67e09d37b0f21c42a3735a1ff9f99e2cd9" => :mavericks
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
