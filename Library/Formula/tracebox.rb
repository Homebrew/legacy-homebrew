class Tracebox < Formula
  homepage "http://www.tracebox.org/"
  url "https://github.com/tracebox/tracebox.git", :tag => "v0.3",
      :revision => "63e89e92164d5f527a8e2bbec08797179b2dacb1"

  bottle do
    cellar :any
    sha1 "96873e5b6be4076c3f66a06e62635fcba085704a" => :mavericks
    sha1 "3958426b9f4034a0dd278610981105124bc4ed26" => :mountain_lion
    sha1 "efd205cf4ccee2bff4ed6ef619d308e349663f1b" => :lion
  end

  head "https://github.com/tracebox/tracebox.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lua"
  depends_on "json-c"

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Tracebox requires superuser privileges e.g. run with sudo.

    You should be certain that you trust any software you are executing with
    elevated privileges.
    EOS
  end
end
