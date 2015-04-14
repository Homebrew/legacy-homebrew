class Elementary < Formula
  homepage "https://www.enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/elementary/elementary-1.14.0.tar.gz"
  sha256 "aa06ca1b332b3cd29ffd136c1f10edf08a06906b3532785ce7e390c1cad6090e"

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
