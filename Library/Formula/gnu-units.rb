class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "http://ftpmirror.gnu.org/units/units-2.02.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.02.tar.gz"
  sha256 "2b34fa70c9319956135b990afc1ac99d411ba5b291b5d29e4a89fdf052944e9a"

  bottle do
    revision 1
    sha256 "0f5e5b0454bdd6deb29457017d5fbd5b61b84f51a9aba3be9d55f835f1792cbc" => :yosemite
    sha256 "c5f37a10a445c5c71a501d2680f2b00c49610a78e79619765b82400acd841afa" => :mavericks
    sha256 "f2c7e44bcf0dfe0be3da8b09cbfaf979793e3a4245ce7c0969bb45b7e0d881e2" => :mountain_lion
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
