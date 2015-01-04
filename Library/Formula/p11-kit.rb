class P11Kit < Formula
  homepage "http://p11-glue.freedesktop.org"
  url "http://p11-glue.freedesktop.org/releases/p11-kit-0.18.4.tar.gz"
  sha256 "df5424ec39e17c2b3b98819bf772626e9b8c73871a8b82e54151f6297d8575fd"

  bottle do
    sha1 "1f75969e6cbf89921ba4d205e093c6d7bddd755e" => :yosemite
    sha1 "4baec782e0d55aacb458bcd752d32f4d63de4424" => :mavericks
    sha1 "1f16ca29e9c9b38ec832ce04c3802d439c2ba896" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtasn1"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-trust-module"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
