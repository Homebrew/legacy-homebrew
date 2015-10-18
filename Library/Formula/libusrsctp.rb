class Libusrsctp < Formula
  desc "User-land SCTP stack"
  homepage "http://sctp.fh-muenster.de/sctp-user-land-stack.html"
  url "http://sctp.fh-muenster.de/download/libusrsctp-0.9.1.tar.gz"
  sha256 "63a3abe5f1cb7ddde36cba09d32579b05a98badb06ff88fca87d024925c3ff16"

  bottle do
    cellar :any
    revision 1
    sha1 "5b540e94ed9273d09eba0e213014d2060cb27a0c" => :yosemite
    sha1 "04778d2ae6555f8916eea463e70441de02665da0" => :mavericks
    sha1 "b4c7f0a6851ce53f9d48091995bd523d4dbc7262" => :mountain_lion
  end

  head do
    url "http://sctp-refimpl.googlecode.com/svn/trunk/KERN/usrsctp"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
