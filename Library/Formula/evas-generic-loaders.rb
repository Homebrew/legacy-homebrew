class EvasGenericLoaders < Formula
  homepage "https://enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/evas_generic_loaders/evas_generic_loaders-1.14.0-beta3.tar.gz"
  sha256 "fcbbafe0275e0e72786482dd25400c19f0c017c8bada51a7fca054c609342b11"

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
