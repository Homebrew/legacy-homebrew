class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.21.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/notmuch/notmuch_0.21.orig.tar.gz"
  sha256 "d06f8ffed168c7d53ffc449dd611038b5fa90f7ee22d58f3bec3b379571e25b3"

  bottle do
    cellar :any
    sha256 "9242a69747a74542b5eafce2e9011621f47754f26abbe6343fdd66a9ec00eaef" => :el_capitan
    sha256 "71dec597c7bdc80560dae9a7be082f1338198e05ff58b11433f6ef5cee47c5c1" => :yosemite
    sha256 "a5e09b5d4f8f441208d27769170d3bb75b55ea7c9c871a2d34ca2807af52f98f" => :mavericks
    sha256 "78bd94ae533358108c9dfcebec77b8b3e77ba77f3056f536d0ebd4d2a1b648d5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on :emacs => ["21.1", :optional]
  depends_on :python => :optional
  depends_on :python3 => :optional
  depends_on "xapian"
  depends_on "talloc"
  depends_on "gmime"
  depends_on "homebrew/dupes/zlib" unless OS.mac?

  # Requires zlib >= 1.2.5.2
  resource "zlib" do
    url "http://zlib.net/zlib-1.2.8.tar.gz"
    sha256 "36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d"
  end if OS.mac?

  def install
    resource("zlib").stage do
      system "./configure", "--prefix=#{buildpath}/zlib", "--static"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/zlib/lib/pkgconfig"
    end if OS.mac?

    args = ["--prefix=#{prefix}"]
    if build.with? "emacs"
      ENV.deparallelize # Emacs and parallel builds aren't friends
      args << "--with-emacs" << "--emacslispdir=#{elisp}"
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
