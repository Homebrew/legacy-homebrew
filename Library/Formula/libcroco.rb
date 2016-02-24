class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.11.tar.xz"
  sha256 "132b528a948586b0dfa05d7e9e059901bca5a3be675b6071a90a90b81ae5a056"

  bottle do
    cellar :any
    sha256 "63df1fc35be64690e7a9e8557e6049c0086a9f284f3ae4964e016ff99ebbdf38" => :el_capitan
    sha256 "1e620e3c0b584702c9d4dde4cfeec359c8874f364d342d2e1ead68adb520ceed" => :yosemite
    sha256 "341aada2eec7e3b3db71a9eca1da5b8df6127e2d4cec90cdbb1d2ec24de27eed" => :mavericks
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
