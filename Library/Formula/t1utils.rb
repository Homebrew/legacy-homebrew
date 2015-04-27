class T1utils < Formula
  homepage "http://www.lcdf.org/type/"
  url "http://www.lcdf.org/type/t1utils-1.39.tar.gz"
  sha256 "0faef3e5c4927b38b05ac99ee177b7d7cddbbf5b4452f98b244f684b52b0d4c4"

  head do
    url "https://github.com/kohler/t1utils.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/t1mac", "--version"
  end
end
