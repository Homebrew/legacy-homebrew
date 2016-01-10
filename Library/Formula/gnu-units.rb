class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "http://ftpmirror.gnu.org/units/units-2.02.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.02.tar.gz"
  sha256 "2b34fa70c9319956135b990afc1ac99d411ba5b291b5d29e4a89fdf052944e9a"

  bottle do
    revision 2
    sha256 "bd921a8062e1975b950e1cd5997972b8e71c04d5b46327bee6d13e09d3eb3c48" => :el_capitan
    sha256 "862fc7428003aa51b056f37399084931306b48db105f3127375e0e75b9c0ff3e" => :yosemite
    sha256 "42fd2183ed7112794b546ac6115fcb2a7204af363d8a8685d40fad704a54dc5a" => :mavericks
  end

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  # Temporary fix for "invalid/nonprinting UTF-8" warnings on startup,
  # see https://github.com/Homebrew/homebrew/issues/20297.
  #
  # The current maintainer of GNU units, Adrian Mariano, is aware of
  # the issue (reported by mail on 2015-04-08) and has fixed it in the
  # currently unreleased development version which will be released
  # later this year.
  #
  # See https://github.com/Homebrew/homebrew/issues/38454 for details.
  patch :DATA

  def install
    # OS X does not provide a `python2` executable
    inreplace "units_cur", "#!/usr/bin/python2", "#!/usr/bin/env python"

    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
  end
end

__END__
diff --git a/definitions.units b/definitions.units
index a0c61f2..06269ce 100644
--- a/definitions.units
+++ b/definitions.units
@@ -5248,9 +5248,6 @@ röntgen                 roentgen
 ㍴                      bar
 # ㍵                          oV???
 ㍶                      pc
-#㍷                      dm      invalid on Mac
-#㍸                      dm^2    invalid on Mac
-#㍹                      dm^3    invalid on Mac
 ㎀                      pA
 ㎁                      nA
 ㎂                      µA
@@ -5342,9 +5339,6 @@ röntgen                 roentgen
 ㏛                      sr
 ㏜                      Sv
 ㏝                      Wb
-#㏞                      V/m     Invalid on Mac
-#㏟                      A/m     Invalid on Mac
-#㏿                      gal     Invalid on Mac

 !endutf8
