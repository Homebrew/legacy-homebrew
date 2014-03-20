require 'formula'

class Aspcud < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/aspcud/1.8.0/aspcud-1.8.0-source.tar.gz'
  sha1 '8e05dca2bcf3a388a985317b71f2fcd5586351f7'

  depends_on 'boost' => :build
  depends_on 'cmake' => :build
  depends_on 're2c'  => :build
  depends_on 'gringo'
  depends_on 'clasp'

  patch :DATA

  def install
    system "make"
    inreplace "scripts/aspcud.sh", "$base/encodings", "#{share}/encodings"
    bin.install "build/release/bin/cudf2lp"
    bin.install "scripts/aspcud.sh" => "aspcud"
    share.install "scripts/encodings"
  end
end

__END__
FreeBSD SVN: http://svnweb.freebsd.org/ports/head/math/aspcud/files/patch-libcudf-src-dependency.cpp?revision=339367
--- a/libcudf/src/dependency.cpp.orig	2014-01-10 15:13:07.000000000 +0000
+++ b/libcudf/src/dependency.cpp	2014-01-10 15:29:32.000000000 +0000
@@ -49,6 +49,7 @@
     struct CudfPackageRefFilter
     {
         CudfPackageRefFilter(const Cudf::PackageRef &ref) : ref(ref) { }
+		CudfPackageRefFilter &operator = (const CudfPackageRefFilter &t) { return *this; }
         bool operator()(const Entity *entity)
         {
             switch(ref.op)
--- a/scripts/aspcud.sh.orig	2014-01-10 09:34:53.000000000 +0000
+++ b/scripts/aspcud.sh		2014-01-12 00:02:07.000000000 +0000
@@ -60,7 +62,20 @@
	echo
 }

-base="$(dirname "$(readlink -f "$0")")"
+# solve the missing `readlink -f` option on OSX
+canonical_readlink()
+{
+  cd `dirname $1`;
+  __filename=`basename $1`;
+  if [ -h "$__filename" ]; then
+    canonical_readlink `readlink $__filename`;
+  else
+    echo "`pwd -P`/$__filename";
+  fi
+}
+
+
+base=$(canonical_readlink $0)

 # default options
 clasp_opts_def=( "--opt-heu=1" "--sat-prepro" "--restarts=L,128" "--heuristic=VSIDS" "--opt-hierarch=1" "--local-restarts" "--del-max=200000,250" "--save-progress=0" )
@@ -125,8 +125,16 @@
 [[ ${#gringo_opts[*]} -eq 0 ]] && gringo_opts=( "${gringo_opts_def[@]}" )
 clasp_opts=( "${clasp_opts[@]}" "${clasp_opts_implicit[@]}" )

+trendycriterion="-count(removed),-notuptodate(solution),-unsat_recommends(solution),-count(new)"
+
+if [[ $3 == trendy ]]; then
+    criterion=$trendycriterion;
+else
+    criterion=`echo $3 | sed -E -e 's/([+-])(new|removed|changed)/\1count(\2)/g' -e 's/([+-])(notuptodate|unsat_recommends)([^(]|$)/\1\2(solution)\3/g' -e 's/([+-])sum(([a-z]*))/\1sum(\2,solution)/g'`
+fi
+
 if [[ $# -eq 3 ]]; then
-	cudf_opts=( "${cudf_opts[@]}" "-c" "$3" )
+	cudf_opts=( "${cudf_opts[@]}" "-c" "$criterion" )
 elif echo $(basename "$0") | grep -q "paranoid"; then
	[[ $# -ne 2 ]] && { die "error: exactly two arguments expected"; }
	cudf_opts=( "${cudf_opts[@]}" "-c" "paranoid" )
