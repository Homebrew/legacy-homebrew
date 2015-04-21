class EvasGenericLoaders < Formula
  homepage "https://enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/evas_generic_loaders/evas_generic_loaders-1.14.0-beta2.tar.gz"
  sha256 "7434f7230b8a46369b84489a8bb0e97c64f35fffabdda8ab0a788870408b9b35"

  depends_on "pkg-config" => :build
  depends_on "efl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
