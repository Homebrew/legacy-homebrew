class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "http://tmate.io"
  url "https://github.com/tmate-io/tmate/archive/2.2.1.tar.gz"
  sha256 "d9c2ac59f42e65aac5f500f0548ea8056fd79c9c5285e5af324d833e2a84c305"

  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    sha256 "326f5800d76388a6358e0252a6899b980461982dbdfb075b00b6849ab65818c7" => :el_capitan
    sha256 "fad3dc525a08d72c4d3bdd859f576f90548e6b63cb856ec616c07158efdfaba5" => :yosemite
    sha256 "4f434596b976a5cb099f83d18229b22942cbe21d98ec9a04af72ff29e36e41c6" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libevent"
  depends_on "libssh"
  depends_on "msgpack"

  def install
    system "sh", "autogen.sh"

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/tmate", "-V"
  end
end
