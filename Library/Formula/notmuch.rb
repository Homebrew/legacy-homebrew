require "formula"

class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "http://notmuchmail.org"
  url "http://notmuchmail.org/releases/notmuch-0.19.tar.gz"
  sha1 "df023988f67e329357a5e8d00c4f6fc71249b89f"

  bottle do
    cellar :any
    sha1 "000f3f7ab9e2a78db874ba95f2a7e73d96cbdcd9" => :yosemite
    sha1 "43d716940b5b99923ef14dd207fab1c9eb9e591f" => :mavericks
    sha1 "c5bcffd7d593c4c5dffb85d42b33bdfff26ff113" => :mountain_lion
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
    sha1 "a4d316c404ff54ca545ea71a27af7dbc29817088"
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

    Language::Python.each_python(build) do |python, version|
      cd "bindings/python" do
        system python, *Language::Python.setup_install_args(prefix)
      end
    end

  end
end
