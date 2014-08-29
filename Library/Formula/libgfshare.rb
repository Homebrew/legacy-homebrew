require 'formula'

class Libgfshare < Formula
  homepage 'http://www.digital-scurf.org/software/libgfshare'
  url 'http://www.digital-scurf.org/files/libgfshare/libgfshare-1.0.5.tar.gz'
  sha1 '165c721e04a2aa0bd2f3b14377bca8f65603640a'

  bottle do
    cellar :any
    sha1 "bda0bece28f63537a3870201a45f6f5ba564f12b" => :mavericks
    sha1 "260dcac422afd230d723bcdc15e9dbc5ffcdce2c" => :mountain_lion
    sha1 "ed3cea134c320e070bf12903bdf56ff50a326032" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-linker-optimisations",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "test.in"
    system "#{bin}/gfsplit", "test.in"
    system "#{bin}/gfcombine test.in.*"
  end
end
