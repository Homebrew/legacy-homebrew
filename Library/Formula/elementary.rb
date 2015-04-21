class Elementary < Formula
  homepage "https://www.enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/elementary/elementary-1.14.0-beta2.tar.gz"
  sha256 "d577b1a2ec3d90d351eec002ba74bedbe65e5990fa2da4fde2e458e788290c6a"

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
