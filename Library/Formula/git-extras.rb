class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  head "https://github.com/tj/git-extras.git"

  stable do
    url "https://github.com/tj/git-extras/archive/4.1.0.tar.gz"
    sha256 "d4c028e2fe78abde8f3e640b70f431318fb28d82894dde22772efe8ba3563f85"
    # Disable "git extras update", which will produce a broken install under Homebrew
    # https://github.com/Homebrew/homebrew/issues/44520
    # https://github.com/tj/git-extras/pull/491
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f820c2530817015aa26f4fd8879e67847496b4c958a232adfde962dcd7b5a488" => :el_capitan
    sha256 "6a9555f8c96d1b2bc146eaf1778dee50787f44ee4d98b21a862b50a17556dc47" => :yosemite
    sha256 "1b0d3064c639782265ed8180c3136e86cfc65e8fa607a3b347113320888e85fe" => :mavericks
  end

  conflicts_with "git-town", :because => "git-extras also ships a git-sync binary"

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
