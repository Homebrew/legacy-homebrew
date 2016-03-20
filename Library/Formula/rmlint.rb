class Rmlint < Formula
  desc "remove duplicates and lint from your filesystem"
  homepage "http://rmlint.rtfd.org"
  url "https://github.com/sahib/rmlint/archive/v2.4.3.tar.gz"
  sha256 "499c38449038c30b7704760d1251f0098fb28f6037e54c434ef24d6d18d0b5a5"

  depends_on "glib" => :build
  depends_on "scons" => :build
  depends_on "gettext" => [:build, :recommended]
  depends_on "sphinx" => [:build, :optional]
  depends_on "gtk+" => :recommended # for gui
  depends_on "PyGObject" => :recommended # for gui
  depends_on "libelf" => :optional

  def install
    scons
    bin.install("rmlint")
  end

  test do
    system "echo just a test text >> test1.txt"
    system "echo just a test text >> test2.txt"
    system "rmlint"
    system "./rmlint.sh", "-d"

    assert (File.exist?("test1.txt") ^ File.exist?("test2.txt"))
  end
end
