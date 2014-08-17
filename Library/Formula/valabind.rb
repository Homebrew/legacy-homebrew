require "formula"

class Valabind < Formula
  homepage "http://radare.org/"
  head "https://github.com/radare/valabind.git"
  url "https://github.com/radare/valabind/archive/0.8.0.tar.gz"
  sha1 "f677110477e14c2e18ac61c56730ab0e51ac450d"

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  # Fixes an issue in the vala version detection script.
  # https://github.com/radare/valabind/pull/24
  patch :DATA

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end

__END__
diff --git i/getvv w/getvv
index 14183dc..59a42bb 100755
--- i/getvv
+++ w/getvv
@@ -3,7 +3,7 @@ IFS=:
 [ -z "${VALAC}" ] && VALAC=valac
 for a in $PATH; do
 	if [ -e "$a/valac" ]; then
-		v=$(strings $a/${VALAC} | grep vala- | grep -v lib)
+		v=$(cat $a/${VALAC} | strings | grep vala- | grep -v lib)
 		if [ -n "$v" ]; then
 			printf lib$v
 			exit 0
