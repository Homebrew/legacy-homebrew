require 'formula'

class Pass < Formula
  homepage 'http://zx2c4.com/projects/password-store'
  url 'http://git.zx2c4.com/password-store/snapshot/password-store-1.3.tar.xz'
  sha256 'dd0e8e144e0ee1748dbeb58514f975fea5777576316a6e3760556b20cbd1000b'
  head 'http://git.zx2c4.com/password-store', :using => :git

  depends_on 'xz' => :build
  depends_on 'pwgen'
  depends_on 'tree'
  depends_on 'gnu-getopt'
  depends_on 'gnupg2'

  def patches
    # Use ramdisk for volatile storage in OSX.
    # At the moment, upstream does not have interest in merging this,
    # though perhaps they might be pursuaded otherwise later.
    DATA
  end

  def install
    inreplace "src/password-store.sh" do |s|
      s.gsub! "gpg ", "gpg2 "
      s.gsub! "xclip -o -selection clipboard", "pbpaste"
      s.gsub! "xclip -selection clipboard", "pbcopy"
      s.gsub! "qdbus", "#qdbus"
      s.gsub! "base64", "openssl base64"
      s.gsub! "getopt", "#{HOMEBREW_PREFIX}/opt/gnu-getopt/bin/getopt"
    end
    inreplace "man/pass.1", "xclip", "pbcopy"

    system "make DESTDIR=#{prefix} PREFIX=/ install"
  end

  def test
      system '#{bin}/pass --version'
  end


end

__END__
diff --git a/src/password-store.sh b/src/password-store.sh
index 76c7385..f56e323 100755
--- a/src/password-store.sh
+++ b/src/password-store.sh
@@ -239,6 +239,19 @@ case "$command" in
 
 		if [[ -d /dev/shm && -w /dev/shm && -x /dev/shm ]]; then
 			tmp_dir="$(TMPDIR=/dev/shm mktemp -t $template -d)"
+		elif [[ $(uname) = "Darwin" ]]; then
+			cleanup_tmp() {
+				[[ -d $tmp_dir ]] || return
+				rm -rf "$tmp_file" "$tmp_dir" 2>/dev/null
+				umount "$tmp_dir"
+				diskutil quiet eject "$ramdisk_dev"
+				rmdir "$tmp_dir"
+			}
+			trap cleanup_tmp INT TERM EXIT
+			tmp_dir="$(mktemp -t $template -d)"
+			ramdisk_dev="$(hdid -drivekey system-image=yes -nomount 'ram://32768' | cut -d ' ' -f 1)" # 32768 sectors = 16 mb
+			newfs_hfs -M 700 "$ramdisk_dev" &>/dev/null || exit 1
+			mount -t hfs -o noatime -o nobrowse "$ramdisk_dev" "$tmp_dir" || exit 1
 		else
 			prompt=$(echo    "Your system does not have /dev/shm, which means that it may"
 			         echo    "be difficult to entirely erase the temporary non-encrypted"

