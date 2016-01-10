class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "http://www.tracebox.org/"
  url "https://github.com/tracebox/tracebox.git", :tag => "v0.3.1",
                                                  :revision => "aec062dcf7198c8b8f3b90ee4216e929ebf0ffcb"

  bottle do
    cellar :any
    sha256 "4a8348264f1b28160c41f8d2f723c3a866ba2d430d9ee0388e61d6b15599ce64" => :yosemite
    sha256 "3cf26c9f63b463048eea103b7eac1faeea873dd85391673f590161f4dc0e9416" => :mavericks
    sha256 "03ce10b37ac2bcb7cad32594899fe650fc49cf47ed2f4336e300a18e6f30f12d" => :mountain_lion
  end

  head "https://github.com/tracebox/tracebox.git"

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lua"
  depends_on "json-c"

  def install
    ENV.libcxx
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
