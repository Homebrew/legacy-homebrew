class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.23/libgit2-glib-0.23.8.tar.xz"
  sha256 "50853d1fbdabcdf67c14d3295a973c1c6f625b7d298459e494135a31984f140b"

  bottle do
    sha256 "caeab7eef292c86c3e0e121b7faeab0f908fedc1d8af6a5d3b5b36c00344d0e7" => :el_capitan
    sha256 "b50336ab927fd30c0f4debc2146c4800c6af0f64b686b3de91977e1403d57e9a" => :yosemite
    sha256 "de5fc8739133a9ef2b1c1eba7b50df94058bc17face4f164fabdec890363365f" => :mavericks
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
