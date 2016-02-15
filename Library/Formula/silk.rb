class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.10.2.tar.gz"
  sha256 "56b9c481305737057cd8ca07758bfd476a21e3cf905943a2068cb2aa6120007a"

  bottle do
    sha256 "b7d3b94b4934e686934092de3e35b579fcd9df42e919d3c2254c7376fc993034" => :yosemite
    sha256 "0fccbeb99d27c04f5f8b5ecdc57866444852e77bdc124cfea97be13069a314aa" => :mavericks
    sha256 "add00c8ccdbf6c9ad91f015be30191ab73bc0b834add1214353c55f8780dc4fb" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-ipv6",
                          "--enable-data-rootdir=#{var}/silk"
    system "make"
    system "make", "install"

    (var+"silk").mkpath
  end

  test do
    input = test_fixtures("test.pcap")
    output = shell_output("yaf --in #{input} | #{bin}/rwipfix2silk | #{bin}/rwcount --no-titles --no-column")
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end
