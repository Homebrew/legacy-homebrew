class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/4.0.0.tar.gz"
  sha256 "4adaadc1f22f3240ae9607963ede29a5c010ae14b877b90c27d17d6b0c06f430"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63f77e06b416f08bc7a55056d03cda28fbc35ef4cfd1c7934c8d261a03893c0c" => :el_capitan
    sha256 "2136bb696bc80dc637da2f97ccd83d5c8b55494d639386b7c661b092955a9a1c" => :yosemite
    sha256 "04ffdb7d30d88977a15585638fc869a7719bc2cb740cb052dc580893558f22ef" => :mavericks
  end

  stable do
    # Disable "git extras update", which will produce a broken install under Homebrew
    # https://github.com/Homebrew/homebrew/issues/44520
    # https://github.com/tj/git-extras/pull/491
    patch :DATA
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "git", "init"
    assert_match /#{testpath}/, shell_output("#{bin}/git-root")
  end
end

__END__
diff --git a/bin/git-extras b/bin/git-extras
index 3856179..e2ac72c 100755
--- a/bin/git-extras
+++ b/bin/git-extras
@@ -4,13 +4,12 @@ VERSION="4.0.0"
 INSTALL_SCRIPT="https://raw.githubusercontent.com/tj/git-extras/master/install.sh"

 update() {
-  local bin=$(which git-extras)
-  local prefix=${bin%/*/*}
-  local orig=$PWD
-
-  curl -s $INSTALL_SCRIPT | PREFIX="$prefix" bash /dev/stdin \
-    && cd "$orig" \
-    && echo "... updated git-extras $VERSION -> $(git extras --version)"
+  echo "This git-extras installation is managed by Homebrew."
+  echo "If you'd like to update git-extras, run the following:"
+  echo
+  echo "  brew upgrade git-extras"
+  echo
+  return 1
 }

 updateForWindows() {
