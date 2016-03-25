class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.10.2.tar.gz"
  sha256 "56b9c481305737057cd8ca07758bfd476a21e3cf905943a2068cb2aa6120007a"

  bottle do
    revision 1
    sha256 "0bfae0e3ca1afd61819501ee8f2f43ae9e945cc3cc903bcc9682deaab4e94357" => :el_capitan
    sha256 "3654785d4b84d693e808af69c4d9945cbd68a7bfb0ff6f1028ea405ec25ce74c" => :yosemite
    sha256 "d096816e48aecd4f1b87bc016611d0082aea5becf3c43112826e61cff7dd48fd" => :mavericks
  end

  option "with-python", "Build with the PySiLK python interface"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"
  depends_on :python => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --mandir=#{man}
      --enable-ipv6
      --enable-data-rootdir=#{var}/silk
    ]

    if build.with? "python"
      args << "--with-python" << "--with-python-prefix=#{prefix}"
    end
    system "./configure", *args
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
