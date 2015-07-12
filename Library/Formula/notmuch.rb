class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "http://notmuchmail.org"
  url "http://notmuchmail.org/releases/notmuch-0.20.tar.gz"
  sha256 "98475574bfa1341049639ce181f1293b2a8c077a2eb695d96723569e2d2b6d07"

  bottle do
    cellar :any
    sha256 "557573521aa7783958f6e59bfee86f0e8f277b706654719d5c16e5b9f394c2d3" => :yosemite
    sha256 "8dc378548f7440c0ce65c170d7ded3aa3115dcb4279b1a2837812a43635d777b" => :mavericks
    sha256 "11c66bda0c45eac434830bc83bc9365c5ef6dbff08e3b872b3b2001282ede8ae" => :mountain_lion
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
