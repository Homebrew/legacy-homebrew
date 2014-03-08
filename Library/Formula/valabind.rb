require 'formula'

class Valabind < Formula
  homepage 'http://radare.org/'
  url 'https://github.com/radare/valabind/archive/0.8.0.tar.gz'
  sha1 'f677110477e14c2e18ac61c56730ab0e51ac450d'

  head 'https://github.com/radare/valabind.git'

  depends_on 'pkg-config' => :build
  depends_on 'swig' => :run
  depends_on 'vala'

  def patches; DATA; end

  def install
    system 'make'
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end

__END__
diff --git i/getvv w/getvv
index 14183dc..359b75b 100755
--- i/getvv
+++ w/getvv
@@ -2,7 +2,10 @@
 IFS=:
 [ -z "${VALAC}" ] && VALAC=valac
 for a in $PATH; do
+	echo "path={${a}}">/dev/stderr
 	if [ -e "$a/valac" ]; then
+	        echo " * valac: $a/${VALAC}">/dev/stderr
+		strings $a/${VALAC} >/dev/stderr
 		v=$(strings $a/${VALAC} | grep vala- | grep -v lib)
 		if [ -n "$v" ]; then
 			printf lib$v
