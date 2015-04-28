class Elementary < Formula
  homepage "https://www.enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/elementary/elementary-1.14.0-beta3.tar.gz"
  sha256 "3432e232afbf2c129049b70ac4ffb399fa7af8b7cca87d7d83cf18d2e19a204d"

  depends_on "pkg-config" => :build
  depends_on "efl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/elementary_codegen", "-V"
  end
end
