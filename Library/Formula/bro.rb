class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/release/bro-2.4.1.tar.gz"
  sha256 "d8b99673a5024630f6bae820c4f8c3ca9029f1167f9e5729c914c66e1fc7c8f6"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "76bdc073c60c45112a9991eb38e21135f65270ba743e0c276cb7b6a8d2777c37" => :el_capitan
    sha256 "0f83cada57fe774994035b1123adc8ddfbe3284f27cca3d4edc297bc4d179bdd" => :yosemite
    sha256 "76f36a6ee0f9312c4111dda7c7fcce7c19dba514aef55f4fd6f593e50a157f5c" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "openssl"
  depends_on "geoip" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
