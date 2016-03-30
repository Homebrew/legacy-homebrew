class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "http://tmate.io"
  url "https://github.com/tmate-io/tmate/archive/2.2.1.tar.gz"
  sha256 "d9c2ac59f42e65aac5f500f0548ea8056fd79c9c5285e5af324d833e2a84c305"
  revision 1

  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    sha256 "a7ee83971e4cc901b0c81e69fe32f205b7fa94bfb24cda381b9b368ea0a651ad" => :el_capitan
    sha256 "dc86e6830f0c0f2293769e96613f92c6a6e6d9eedaea9a7534f46ce7518c8b1d" => :yosemite
    sha256 "180601994c1bb11dbc90ee63fe08d77a9b9304810d444f98e4a5922946d1185a" => :mavericks
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
