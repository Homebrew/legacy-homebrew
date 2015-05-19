class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "http://ftp.gnome.org/pub/GNOME/sources/libgit2-glib/0.22/libgit2-glib-0.22.0.tar.xz"
  sha256 "8ae19e1dd2a6b37dd81843182d96dc5f8d439013c26658670a08287abfedaee2"

  bottle do
    sha1 "81334d37f1176a974f3c09534de672f980c407a7" => :yosemite
    sha1 "b9a9dcc91c8273ead34e39e84bd31e895cfd7325" => :mavericks
    sha1 "0bac1671876c4e38a8a2899661cab44afcdaf051" => :mountain_lion
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
