# coding: utf-8
require "formula"

class GnuUnits < Formula
  homepage "https://www.gnu.org/software/units/"
  url "http://ftpmirror.gnu.org/units/units-2.02.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.02.tar.gz"
  sha1 "e460371dc97034d17ce452e6b64991f7fd2d1409"

  bottle do
    sha1 "255fd50fc880467483ae2654d1c34cd452247847" => :yosemite
    sha1 "43beaf9b66127bd29a393e2386c2c9a53522762f" => :mavericks
    sha1 "7d9b3438fbfeaa0d8a428a1ed6496df9d1c92cc6" => :mountain_lion
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
