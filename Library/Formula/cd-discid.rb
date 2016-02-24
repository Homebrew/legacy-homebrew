class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "http://linukz.org/cd-discid.shtml"
  revision 2
  head "https://github.com/taem/cd-discid.git"

  stable do
    url "http://linukz.org/download/cd-discid-1.4.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/cd-discid/cd-discid_1.4.orig.tar.gz"
    sha256 "ffd68cd406309e764be6af4d5cbcc309e132c13f3597c6a4570a1f218edd2c63"

    # OS X fix; see https://github.com/Homebrew/homebrew/issues/46267
    # Already fixed in upstream head; remove when bumping version to >1.4
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f0c17cfc3c345c661104a6f29562b766cac2a80747feea0c26cda04ece3c8326" => :el_capitan
    sha256 "3331be095997a1e5e6acb9f82f5e5473ed51c0f35976229371dc1d0c703c2e3b" => :yosemite
    sha256 "86f0066d344a2a0a37e3c00d08255d4a505b41cc2c38e7d33ac643d16af8ad71" => :mavericks
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
