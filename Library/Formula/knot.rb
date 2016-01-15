class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-2.0.2.tar.xz"
  sha256 "0418a22f9e801503993b3c872f2403bf73eab5ef7266128789b0531b41ea0c7e"
  revision 1

  head "https://gitlab.labs.nic.cz/labs/knot.git"

  bottle do
    cellar :any
    sha256 "d3a4fb096ec0503c1190c9f2f5149606715688d4dd841e69f000d4939bd6cdbb" => :el_capitan
    sha256 "ed2c25d4630c57cf993ea5dff1086968ac02dd2bdcd8fdbb5d221ea826d823c1" => :yosemite
    sha256 "faf9359de7ca2f7b2285d28c28c8881e35c7e8e30dd843091b73c144243fd139" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libidn"
  depends_on "nettle"
  depends_on "openssl"
  depends_on "userspace-rcu"

  def install
    system "autoreconf", "-i", "-f" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/knot",
                          "--prefix=#{prefix}"

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "install"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"

    (var/"knot").mkpath
  end

  def knot_conf; <<-EOS.undent
    server:
      rundir: "#{var}/knot"
      listen: [ "0.0.0.0@53", "::@53" ]

    log:
      - target: "stderr"
        any: "error"

      - target: "syslog"
        server: "info"
        zone: "warning"
        any: "error"

    control:
      listen: "knot.sock"

    template:
      - id: "default"
        storage: "#{var}/knot"
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>EnableTransactions</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/knotd</string>
        <string>-c</string>
        <string>#{etc}/knot.conf</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/kdig", "www.knot-dns.cz"
    system "#{bin}/khost", "brew.sh"
    system "#{sbin}/knotc", "-c", "#{etc}/knot.conf", "checkconf"
  end
end
