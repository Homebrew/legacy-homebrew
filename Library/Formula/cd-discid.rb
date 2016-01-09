class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "http://linukz.org/cd-discid.shtml"
  url "http://linukz.org/download/cd-discid-1.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cd-discid/cd-discid_1.4.orig.tar.gz"
  sha256 "ffd68cd406309e764be6af4d5cbcc309e132c13f3597c6a4570a1f218edd2c63"
  revision 2
  head "https://github.com/taem/cd-discid.git"

  stable do
    # OS X fix; see https://github.com/Homebrew/homebrew/issues/46267
    # Already fixed in upstream head; remove when bumping version to >1.4
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5f8552d8d7c590fedc966ceecfd5f9840d63e0760c575759f4ba2fcffdd54fd9" => :el_capitan
    sha256 "cb22bb523253be82c72aadd9b016cdbb74e9f861fd109d9a3e0f78a611a306a3" => :yosemite
    sha256 "1b18004d18aa98eacb9eb638c0bce844e57ea277c551965843eefe2378ef315d" => :mavericks
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
index 9b0b40a..2c96641 100644
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
@@ -236,8 +236,7 @@ int main(int argc, char *argv[])
	 * TocEntry[last-1].lastRecordedAddress + 1, so we compute the start
	 * of leadout from the start+length of the last track instead
	 */
-	TocEntry[last].cdte_track_address = TocEntry[last - 1].trackSize +
-		TocEntry[last - 1].trackStartAddress;
+TocEntry[last].cdte_track_address = htonl(ntohl(TocEntry[last-1].trackSize) + ntohl(TocEntry[last-1].trackStartAddress));
 #else   /* FreeBSD, Linux, Solaris */
	for (i = 0; i < last; i++) {
		/* tracks start with 1, but I must start with 0 on OpenBSD */
@@ -260,12 +259,12 @@ int main(int argc, char *argv[])
	/* release file handle */
	close(drive);

-#if defined(__FreeBSD__)
+#if defined(__FreeBSD__) || defined(__DragonFly__) || defined(__APPLE__)
	TocEntry[i].cdte_track_address = ntohl(TocEntry[i].cdte_track_address);
 #endif

	for (i = 0; i < last; i++) {
-#if defined(__FreeBSD__)
+#if defined(__FreeBSD__) || defined(__DragonFly__) || defined(__APPLE__)
		TocEntry[i].cdte_track_address = ntohl(TocEntry[i].cdte_track_address);
 #endif
		cksum += cddb_sum((TocEntry[i].cdte_track_address + CD_MSF_OFFSET) / CD_FRAMES);
