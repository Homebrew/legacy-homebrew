class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/4.0.0.tar.gz"
  sha256 "4adaadc1f22f3240ae9607963ede29a5c010ae14b877b90c27d17d6b0c06f430"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee2ab2e65bf576c2f63132cac7e1e81d764fd48e71897c37b62b7767d7bf4a05" => :el_capitan
    sha256 "d8991a2ec84f64b6add9a4f369b31becc02d32e6b80d48909825339dabafd812" => :yosemite
    sha256 "2a168cd564773f8bb5e936082715df4e624fb1caaf94a9b5a96ca37882c5708c" => :mavericks
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
