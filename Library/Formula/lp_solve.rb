require 'formula'

class LpSolve < Formula
  homepage 'http://sourceforge.net/projects/lpsolve/'
  url 'http://sourceforge.net/projects/lpsolve/files/lpsolve/5.5.2.0/lp_solve_5.5.2.0_source.tar.gz'
  sha1 'e2830053cf079839b9ce21662cbc886ac6d31c80'

  def patches
    # remove compiler flag used for OS X <= 10.3
    DATA
  end

  def install

    cd 'lpsolve55' do
        system "sh ccc.osx"
        lib.install './bin/osx64/liblpsolve55.a','./bin/osx64/liblpsolve55.dylib'
    end

    cd 'lp_solve' do
        system "sh ccc.osx"
        bin.install './bin/osx64/lp_solve'
    end

    include.install Dir['*.h']

  end

  def test
    system "#{bin}/lp_solve", "-h"
  end

end

__END__
diff --git a/lp_solve/ccc.osx b/lp_solve/ccc.osx
index 0066636..9dd42ca 100644
--- a/lp_solve/ccc.osx
+++ b/lp_solve/ccc.osx
@@ -31,6 +31,6 @@ rm /tmp/isnan.c /tmp/isnan >/dev/null 2>&1
 def=
 dl=-ldl

-opts='-idirafter /usr/include/sys -O3 -DINTEGERTIME -Wno-long-double'
+opts='-idirafter /usr/include/sys -O3 -DINTEGERTIME'

 $c -I.. -I../bfp -I../bfp/bfp_LUSOL -I../bfp/bfp_LUSOL/LUSOL -I../colamd -I../shared $opts $def $NOISNAN -DYY_NEVER_INTERACTIVE -DPARSER_LP -DINVERSE_ACTIVE=INVERSE_LUSOL -DRoleIsExternalInvEngine $src -o bin/$PLATFORM/lp_solve $math $dl
diff --git a/lpsolve55/ccc.osx b/lpsolve55/ccc.osx
index 339ccf9..70790a2 100644
--- a/lpsolve55/ccc.osx
+++ b/lpsolve55/ccc.osx
@@ -30,7 +30,7 @@ def=
 dl=-ldl
 so=y

-opts='-idirafter /usr/include/sys -O3 -DINTEGERTIME -Wno-long-double'
+opts='-idirafter /usr/include/sys -O3 -DINTEGERTIME'

 $c -s -c -I.. -I../shared -I../bfp -I../bfp/bfp_LUSOL -I../bfp/bfp_LUSOL/LUSOL -I../colamd $opts $def $NOISNAN -DYY_NEVER_INTERACTIVE -DPARSER_LP -DINVERSE_ACTIVE=INVERSE_LUSOL -DRoleIsExternalInvEngine $src
 libtool -static -o bin/$PLATFORM/liblpsolve55.a `echo $src|sed s/[.]c/.o/g|sed 's/[^ ]*\///g'`

