class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "http://notmuchmail.org"
  url "http://notmuchmail.org/releases/notmuch-0.20.2.tar.gz"
  sha256 "f741a26345bff389fd8a4a119c4174c6585730f71844809583a54ef2a865adec"

  bottle do
    cellar :any
    sha256 "9242a69747a74542b5eafce2e9011621f47754f26abbe6343fdd66a9ec00eaef" => :el_capitan
    sha256 "71dec597c7bdc80560dae9a7be082f1338198e05ff58b11433f6ef5cee47c5c1" => :yosemite
    sha256 "a5e09b5d4f8f441208d27769170d3bb75b55ea7c9c871a2d34ca2807af52f98f" => :mavericks
    sha256 "78bd94ae533358108c9dfcebec77b8b3e77ba77f3056f536d0ebd4d2a1b648d5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "emacs" => :optional
  depends_on :python => :optional
  depends_on :python3 => :optional
  depends_on "xapian"
  depends_on "talloc"
  depends_on "gmime"

  # Requires zlib >= 1.2.5.2
  resource "zlib" do
    url "http://zlib.net/zlib-1.2.8.tar.gz"
    sha256 "36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d"
  end

  def install
    resource("zlib").stage do
      system "./configure", "--prefix=#{buildpath}/zlib", "--static"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/zlib/lib/pkgconfig"
    end

    args = ["--prefix=#{prefix}"]
    if build.with? "emacs"
      ENV.deparallelize # Emacs and parallel builds aren't friends
      args << "--with-emacs"
    else
      args << "--without-emacs"
    end

    system "./configure", *args
    system "make", "V=1", "install"

    Language::Python.each_python(build) do |python, _version|
      cd "bindings/python" do
        system python, *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    system "#{bin}/notmuch", "help"
  end
end
