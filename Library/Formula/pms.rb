class Pms < Formula
  desc "Practical Music Search, an ncurses-based MPD client"
  homepage "http://pms.sourceforge.net"
  url "https://downloads.sourceforge.net/project/pms/pms/0.42/pms-0.42.tar.bz2"
  sha256 "96bf942b08cba10ee891a63eeccad307fd082ef3bd20be879f189e1959e775a6"

  bottle do
    sha256 "4093093ca7be2f6aaee5f50d3185323df4fcea2ed389f29615a1b79fb3648be4" => :yosemite
    sha256 "2f7dd91d357ac34393e55d7de6ffca2b21a64adfa084a6b6dd5c5aa43caed170" => :mavericks
    sha256 "772bff39de0b88e164b5f14b22ed4fa22c274468d07d735318284fee5157d6c1" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Practical Music Search v#{version}/,
                 shell_output("#{bin}/pms -?", 4))
  end
end
