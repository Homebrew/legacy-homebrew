require 'formula'

class Tracebox < Formula
  homepage 'http://www.tracebox.org/'
  head 'https://github.com/tracebox/tracebox.git'
  url 'https://github.com/tracebox/tracebox.git', :tag => 'v0.2'
  revision 1

  bottle do
    cellar :any
    sha1 "96873e5b6be4076c3f66a06e62635fcba085704a" => :mavericks
    sha1 "3958426b9f4034a0dd278610981105124bc4ed26" => :mountain_lion
    sha1 "efd205cf4ccee2bff4ed6ef619d308e349663f1b" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lua"

  def install
    ENV.append "AUTOHEADER", "true"
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    tracebox requires superuser privileges e.g. run with sudo.

    You should be certain that you trust any software you are executing with
    elevated privileges.
    EOS
  end
end
