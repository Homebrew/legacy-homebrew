class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "http://linukz.org/cd-discid.shtml"
  url "http://linukz.org/download/cd-discid-1.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cd-discid/cd-discid_1.4.orig.tar.gz"
  sha256 "ffd68cd406309e764be6af4d5cbcc309e132c13f3597c6a4570a1f218edd2c63"
  head "https://github.com/taem/cd-discid.git"

  # OS X fix; see ps://github.com/Homebrew/homebrew/issues/46267
  # Already fixed in upstream head; remove when bumping version to >1.4
  patch :DATA

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "14cfc760d2cbd99750c84634b964a6950428ac014b8edce68a5262ed8b7605e2" => :el_capitan
    sha256 "b8b56556b0818b6d2dd1bfd389f317dd701abb4c74ebaa187edd2b13565e6851" => :yosemite
    sha256 "9231f27b586840defbdcca95084365c13c6ba85231da20d9bc199b735b9b0d66" => :mavericks
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "cd-discid"
    man1.install "cd-discid.1"
  end

  test do
    assert_equal "cd-discid #{version}.", shell_output("#{bin}/cd-discid --version 2>&1").chomp
  end
end

__END__
diff --git a/cd-discid.c b/cd-discid.c
index 9b0b40a..1a0a594 100644
--- a/cd-discid.c
+++ b/cd-discid.c
@@ -93,7 +93,7 @@
 #define cdth_trk1               lastTrackNumberInLastSessionLSB
 #define cdrom_tocentry          CDTrackInfo
 #define cdte_track_address      trackStartAddress
-#define DEVICE_NAME             "/dev/disk1"
+#define DEVICE_NAME             "/dev/rdisk1"

 #else
 #error "Your OS isn't supported yet."
