class Redshift < Formula
  homepage "http://jonls.dk/redshift/"
  url "https://github.com/jonls/redshift/archive/59023d86f4275128751bcb84ecda5a630bf51857.tar.gz"
  version "1.9.1.59023d8"
  sha1 "66a3a6011cdccb0b9ee77fde0de65da437c72ec5"
  head "https://github.com/jonls/redshift.git"

  depends_on 'autoconf' => :build
  depends_on 'gettext' => :build
  depends_on 'automake' => :build
  depends_on 'intltool' => :build
  depends_on 'glib' => :build
  depends_on 'libtool' => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "redshift", "-x"
  end
end
