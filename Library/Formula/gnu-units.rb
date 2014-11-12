require "formula"

class GnuUnits < Formula
  homepage "https://www.gnu.org/software/units/"
  url "http://ftpmirror.gnu.org/units/units-2.02.tar.gz"
  mirror "http://ftp.gnu.org/gnu/units/units-2.02.tar.gz"
  sha1 "e460371dc97034d17ce452e6b64991f7fd2d1409"

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
  end
end
