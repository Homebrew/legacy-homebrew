class EvasGenericLoaders < Formula
  homepage "https://enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/evas_generic_loaders/evas_generic_loaders-1.14.0-beta1.tar.gz"
  sha256 "787570a63ef59004942b24e9dd28d4e66396c45dcebda105d9f6dfa4b1b6ee16"

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
