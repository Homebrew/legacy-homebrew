class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.8.tar.xz"
  sha256 "ea6e1b858c55219cefd7109756bff5bc1a774ba7a55f7d3ccd734d6b871b8570"

  bottle do
    cellar :any
    sha256 "a7068d12230f2efc87159f09c369b18ea80c6a21273f5fc79677236301aeaef9" => :yosemite
    sha256 "0941b2151777aec8e20df74979185a5fb2aa0794d009a24aa83011e12946e490" => :mavericks
    sha256 "13ee66e3ce36c2728c3120984db89cae4268d9bcfa48446a75bb026ebedde513" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"

  def install
    ENV.libxml2
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic"
    system "make", "install"
  end

  test do
    (testpath/"test.css").write ".brew-pr { color: green }"
    assert_equal ".brew-pr {\n  color : green\n}",
      shell_output("#{bin}/csslint-0.6 test.css").chomp
  end
end
