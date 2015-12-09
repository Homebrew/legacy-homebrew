class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.9.tar.xz"
  sha256 "38b9a6aed1813e55b3ca07a68d1af845ad4d1f984602e9272fe692930c0be0ae"

  bottle do
    cellar :any
    sha256 "a3473ef024c5223325a1de3240d68182f4137f573314d68a792b71bd60573a3a" => :el_capitan
    sha256 "8799bb46166eedd4a65a54b397bd1acf08a423ae3c05a50bcedbde300c43ed72" => :yosemite
    sha256 "cfce473c43e9c832f594d6a5f3ebe4654296fe71ccf8f217aa6fd020d84af2b6" => :mavericks
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
