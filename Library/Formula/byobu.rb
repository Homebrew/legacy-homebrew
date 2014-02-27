require 'formula'

class Byobu < Formula
  homepage 'http://byobu.co'
  url 'https://launchpad.net/byobu/trunk/5.73/+download/byobu_5.73.orig.tar.gz'
  sha1 'b7a27b41c7bc384394fabfe9e589ad2d0c4fcd89'

  depends_on 'coreutils'
  depends_on 'gnu-sed' # fails with BSD sed
  depends_on 'tmux'
  depends_on 'newt' => 'with-python'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  # Reported upstream:
  # https://bugs.launchpad.net/byobu/+bug/1285848
  def patches
    DATA
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end
end

__END__
diff --git a/usr/bin/byobu b/usr/bin/byobu
index a055105..8b05b31 100755
--- a/usr/bin/byobu
+++ b/usr/bin/byobu
@@ -37,15 +37,6 @@ if [ -r "$HOME/.byoburc" ]; then
 	# Ensure that this configuration is usable
 	. "$HOME/.byoburc" || mv -f "$HOME/.byoburc".orig
 fi
-if [ -z "${BYOBU_PREFIX}" ]; then
-	# Find and export the installation location prefix
-	greadlink -f . >/dev/null 2>&1 && export BYOBU_READLINK="greadlink" || export BYOBU_READLINK="readlink"
-	prefix="$(dirname $(dirname $($BYOBU_READLINK -f $0)))"
-	if [ "$prefix" != "/usr" ]; then
-		echo "export BYOBU_PREFIX='$prefix'" >> "$HOME/.byoburc"
-		. "$HOME/.byoburc"
-	fi
-fi
 export BYOBU_CHARMAP=$(locale charmap)
 [ -r "$HOME/.byoburc" ] && . "$HOME/.byoburc"
 [ -z "${BYOBU_PREFIX}" ] && export BYOBU_PREFIX="/usr" || export BYOBU_PREFIX
