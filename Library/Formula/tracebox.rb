require 'formula'

class Tracebox < Formula
  homepage 'http://www.tracebox.org/'
  head 'https://github.com/tracebox/tracebox.git'
  url 'https://github.com/tracebox/tracebox.git', :tag => 'v0.2'

  bottle do
    cellar :any
    sha1 "ec8033c2cd6db48f747cb0d3a1881ae90bccfd81" => :mavericks
    sha1 "08425c77bfbae29a31f4b60acbc614235023a6e7" => :mountain_lion
    sha1 "9a71c329fad5e6e39108e198506fa0b8b2d40e6c" => :lion
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
