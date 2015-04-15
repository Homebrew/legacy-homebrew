class Elementary < Formula
  homepage "https://www.enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/elementary/elementary-1.14.0-beta1.tar.gz"
  sha256 "fe45a8a9e2093c9b7d40aff7692a604099dd21d6eace28e17aa3e8c2c28d0cf5"

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
