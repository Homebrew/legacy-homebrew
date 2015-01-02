class Libgit2Glib < Formula
  homepage "https://github.com/GNOME/libgit2-glib"
  url "http://ftp.gnome.org/pub/GNOME/sources/libgit2-glib/0.0/libgit2-glib-0.0.24.tar.xz"
  sha256 "8a0a6f65d86f2c8cb9bcb20c5e0ea6fd02271399292a71fc7e6852f13adbbdb8"

  bottle do
    sha1 "7224409d10d2d6e2f23ca18ea5e1025a085583ae" => :yosemite
    sha1 "123377a53b05679cd1ef197ee52698ffc5122df1" => :mavericks
    sha1 "40a596eed3adcea6dc523b3574fb90cd6a219acf" => :mountain_lion
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
