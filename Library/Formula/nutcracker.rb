class Nutcracker < Formula
  homepage "https://github.com/twitter/twemproxy"
  url "https://github.com/twitter/twemproxy/archive/v0.4.0.tar.gz"
  sha1 "7bc17d4d78196abeac27c8544efd833849d03f48"
  head "https://github.com/twitter/twemproxy.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    (share+"nutcracker").install "conf",  "notes", "scripts"
  end

  test do
    system "#{opt_sbin}/nutcracker", "-V"
  end
end
