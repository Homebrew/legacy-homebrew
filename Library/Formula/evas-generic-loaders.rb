class EvasGenericLoaders < Formula
  desc "Extra complex image type loaders for Enlightenment"
  homepage "https://enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/evas_generic_loaders/evas_generic_loaders-1.14.0.tar.gz"
  sha256 "943b25427c4e77a3aeae72811557a0b1b7ec4c61aa53922a4c4faf17b3dea812"

  bottle do
    cellar :any
    sha256 "e0b11cef8ea7877673be8374ff89ecbe1b106fa9afc30570087bb12d154eee24" => :yosemite
    sha256 "fe36efe8f64c17ee3223b51273e85ba4e29aa8a540b75a0df371d9b4dc942939" => :mavericks
    sha256 "db0f34eac5d976faaaef067df90a845e5c93277e6d1622acb77144984420a38a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "efl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
