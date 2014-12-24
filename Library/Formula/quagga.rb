# Quagga Routing Suite

class Quagga < Formula
  homepage "http://www.nongnu.org/quagga/"
  url "http://download.savannah.gnu.org/releases/quagga/quagga-0.99.23.1.tar.gz"
  sha1 "0501f527383cfa548a800de9816cf1423f6b2336"

  depends_on "readline" => :build
  depends_on "gawk" => :build

  def install
    ENV.deparallelize
    # Quagga's autotools setup requires some help
    # enable all protocols and management 
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--enable-isisd",
                          "--enable-isis-topology",
                          "--enable-ospf-te",
                          "--enable-opaque-lsa",
                          "--enable-ospfclient=yes",
                          "--enable-ospfapi=yes",
                          "--enable-tcp-zebra",
                          "--enable-vtysh",
                          "--enable-fpm",
                          "--enable-multipath=0",
                          "--enable-rtadv",
                          "--enable-watchquagga",
                          "--enable-user=quagga",
                          "--enable-group=quagga",
                          "--enable-vty-group=quagga",
                          "--enable-configfile-mask=0640",
                          "--enable-logfile-mask=0640"                         
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test quagga`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
