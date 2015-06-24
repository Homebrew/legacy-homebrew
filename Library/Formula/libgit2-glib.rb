class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.22/libgit2-glib-0.22.8.tar.xz"
  sha256 "05c9453b195f1af0df2a5d8bc71472c9fb26d14bb8fbb5b688ad1b8ef7a30959"

  bottle do
    sha256 "d01cf240b6b3c2706d3131c58df04b72ecd93925866ef7730f92d61c30a6fbde" => :yosemite
    sha256 "469f061d7d3ae2381b304390f04f66ed77ae95ef380ce6ada94c6d4cb2344cb2" => :mavericks
    sha256 "5dc6f04fe4df78d8cbef03507e2579643ed2027fa8dda5fb3d8b94ad91510bd5" => :mountain_lion
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
    mkdir "horatio"
    cd "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
