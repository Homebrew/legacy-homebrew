class Cim < Formula
  desc "GNU Simula"
  homepage "https://www.gnu.org/software/cim/"
  url "http://ftpmirror.gnu.org/cim/cim-5.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/cim/cim-5.1.tar.gz"
  sha256 "b90717b66ec400503bdd69e537e8b7f3e8a9d106c3ba9a08a04ae57369a069a9"

  # patch submitted upstream, no response yet.
  # corrects some include paths. corrected files compile under gcc but not
  # clang.  remainder of patch declares non-value-returning functions as void
  # to permit clang compilation.
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.sim").write <<-EOS.undent
      Begin
        outtext("Hello, world.");
      End;
    EOS
    system "#{bin}/cim", "--output=hello", "test.sim"
    assert_match "Hello, world.", shell_output("./hello")
  end
end
__END__
diff -ur ./lib/simset.c ./lib/simset.c
--- ./lib/simset.c	2014-05-18 19:42:40.000000000 -0400
+++ ./lib/simset.c	2016-03-04 18:23:44.000000000 -0500
@@ -1,7 +1,7 @@
 /*Cim_ccode*/
-#include "../../lib/cim.h"
+#include "../lib/cim.h"
 void __m_SIMSET();
-__map __mapSIMSET[3]={"../../lib/simset.sim",0L,1L,
+__map __mapSIMSET[3]={"../lib/simset.sim",0L,1L,
 "",-123L,124L,
 "",0L,9223372036854775807L};
 typedef struct /*  */
@@ -231,119 +231,119 @@
 extern __ptyp __p221SIMSET;__pty   __pl221SIMSET[1]={&__p221SIMSET};
 __ptyp __p221SIMSET={'P',0,4,sizeof(__bs221),25,__m_SIMSET,0,0,3,0,__rl221SIMSET,0,__pl221SIMSET,__NULL};
 void __m_SIMSET(void){goto __s;
-# 25 "../../lib/simset.sim"
+# 25 "../lib/simset.sim"
 __sto= (__dhp)&__blokk205SIMSET;__rb(&__p205SIMSET);goto __ll0;/* START CLASS SIMSET *//* START CLASS LINKAGE *//* START PROCEDURE SUC */__l8:
-# 31 "../../lib/simset.sim"
+# 31 "../lib/simset.sim"

-# 32 "../../lib/simset.sim"
+# 32 "../lib/simset.sim"
 ;((__bs208 *)__lb)->er=(((__bp=(__rin(((__bs207 *)__lb->sl)->zzsuc,&__p211SIMSET)?((__bs207 *)__lb->sl)->zzsuc:__NULL))!=__NULL && (__bp->pp->pref[1]!= &__p211SIMSET))?(__dhp)__rerror(__errqual):__bp);__er=((__bs208 *)__lb)->er;__rep();goto __sw;/* SLUTT PROCEDURE SUC *//* START PROCEDURE PRED */__l9:
-# 34 "../../lib/simset.sim"
+# 34 "../lib/simset.sim"

-# 35 "../../lib/simset.sim"
+# 35 "../lib/simset.sim"
 ;((__bs209 *)__lb)->er=(((__bp=(__rin(((__bs207 *)__lb->sl)->zzpred,&__p211SIMSET)?((__bs207 *)__lb->sl)->zzpred:__NULL))!=__NULL && (__bp->pp->pref[1]!= &__p211SIMSET))?(__dhp)__rerror(__errqual):__bp);__er=((__bs209 *)__lb)->er;__rep();goto __sw;/* SLUTT PROCEDURE PRED *//* START PROCEDURE PREV */__l10:
-# 37 "../../lib/simset.sim"
+# 37 "../lib/simset.sim"
 ;((__bs210 *)__lb)->er=((__bs207 *)__lb->sl)->zzpred;__er=((__bs210 *)__lb)->er;__rep();goto __sw;/* SLUTT PROCEDURE PREV */__l5:
-# 28 "../../lib/simset.sim"
+# 28 "../lib/simset.sim"
 __renddecl(0);goto __sw;__l6:__rinner(0);goto __sw;__l7:
-# 39 "../../lib/simset.sim"
+# 39 "../lib/simset.sim"
 __rendclass(0);goto __sw;/* SLUTT CLASS LINKAGE *//* START CLASS LINK *//* START PROCEDURE OUT */__l14:
-# 45 "../../lib/simset.sim"
+# 45 "../lib/simset.sim"

-# 46 "../../lib/simset.sim"
+# 46 "../lib/simset.sim"
 ;if(!((((__bs207 *)__lb->sl)->zzsuc!=__NULL)))goto __ll1;
-# 47 "../../lib/simset.sim"
+# 47 "../lib/simset.sim"
 ;((__bs207 *)((__bp=((__bs207 *)__lb->sl)->zzsuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzpred=((__bs207 *)__lb->sl)->zzpred;
-# 48 "../../lib/simset.sim"
+# 48 "../lib/simset.sim"
 ;((__bs207 *)((__bp=((__bs207 *)__lb->sl)->zzpred)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsuc=((__bs207 *)__lb->sl)->zzsuc;
-# 49 "../../lib/simset.sim"
+# 49 "../lib/simset.sim"
 ;((__bs207 *)__lb->sl)->zzsuc=((__bs207 *)__lb->sl)->zzpred=__NULL;
-# 50 "../../lib/simset.sim"
+# 50 "../lib/simset.sim"
 __ll1:__repp();goto __sw;/* SLUTT PROCEDURE OUT *//* START PROCEDURE FOLLOW */__l15:
-# 52 "../../lib/simset.sim"
+# 52 "../lib/simset.sim"
 (((__bp=((__bs213 *)__lb)->PTR)!=__NULL && (__bp->pp->pref[0]!= &__p207SIMSET))?(__dhp)__rerror(__errqual):__bp);
-# 53 "../../lib/simset.sim"
+# 53 "../lib/simset.sim"
 __sl=__lb->sl;__rcpp(&__p212SIMSET);__rcpb(26,__m_SIMSET);goto __sw;__l26:;;
-# 54 "../../lib/simset.sim"
+# 54 "../lib/simset.sim"
 ;if(!(((((__bs213 *)__lb)->PTR!=__NULL)&&(((__bs207 *)((__bp=((__bs213 *)__lb)->PTR)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsuc!=__NULL))))goto __ll2;
-# 55 "../../lib/simset.sim"
+# 55 "../lib/simset.sim"
 ;((__bs207 *)__lb->sl)->zzpred=((__bs213 *)__lb)->PTR;
-# 56 "../../lib/simset.sim"
+# 56 "../lib/simset.sim"
 ;((__bs207 *)__lb->sl)->zzsuc=((__bs207 *)((__bp=((__bs213 *)__lb)->PTR)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsuc;
-# 57 "../../lib/simset.sim"
+# 57 "../lib/simset.sim"
 (((__bs213 *)__lb)->__r1=(((__bs207 *)__lb->sl)->zzsuc));((__bs207 *)((__bp=((__bs213 *)__lb)->__r1)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzpred=((__bs207 *)((__bp=((__bs213 *)__lb)->PTR)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsuc=__lb->sl;
-# 58 "../../lib/simset.sim"
+# 58 "../lib/simset.sim"
 __ll2:__repp();goto __sw;/* SLUTT PROCEDURE FOLLOW *//* START PROCEDURE PRECEDE */__l16:
-# 60 "../../lib/simset.sim"
+# 60 "../lib/simset.sim"
 (((__bp=((__bs214 *)__lb)->PTR)!=__NULL && (__bp->pp->pref[0]!= &__p207SIMSET))?(__dhp)__rerror(__errqual):__bp);
-# 61 "../../lib/simset.sim"
+# 61 "../lib/simset.sim"
 __sl=__lb->sl;__rcpp(&__p212SIMSET);__rcpb(27,__m_SIMSET);goto __sw;__l27:;;
-# 62 "../../lib/simset.sim"
+# 62 "../lib/simset.sim"
 ;if(!(((((__bs214 *)__lb)->PTR!=__NULL)&&(((__bs207 *)((__bp=((__bs214 *)__lb)->PTR)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzpred!=__NULL))))goto __ll3;
-# 63 "../../lib/simset.sim"
+# 63 "../lib/simset.sim"
 ;((__bs207 *)__lb->sl)->zzsuc=((__bs214 *)__lb)->PTR;
-# 64 "../../lib/simset.sim"
+# 64 "../lib/simset.sim"
 ;((__bs207 *)__lb->sl)->zzpred=((__bs207 *)((__bp=((__bs214 *)__lb)->PTR)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzpred;
-# 65 "../../lib/simset.sim"
+# 65 "../lib/simset.sim"
 (((__bs214 *)__lb)->__r1=(((__bs207 *)__lb->sl)->zzpred));((__bs207 *)((__bp=((__bs214 *)__lb)->__r1)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsuc=((__bs207 *)((__bp=((__bs214 *)__lb)->PTR)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzpred=__lb->sl;
-# 66 "../../lib/simset.sim"
+# 66 "../lib/simset.sim"
 __ll3:__repp();goto __sw;/* SLUTT PROCEDURE PRECEDE *//* START PROCEDURE INTO */__l17:
-# 68 "../../lib/simset.sim"
+# 68 "../lib/simset.sim"
 (((__bp=((__bs215 *)__lb)->S)!=__NULL && (__bp->pp->pref[1]!= &__p216SIMSET))?(__dhp)__rerror(__errqual):__bp);__sl=__lb->sl;__rcpp(&__p214SIMSET);((__bs214 *)__pb)->PTR=((__bs215 *)__lb)->S;__rcpb(28,__m_SIMSET);goto __sw;__l28:;;__repp();goto __sw;/* SLUTT PROCEDURE INTO */__l11:
-# 42 "../../lib/simset.sim"
+# 42 "../lib/simset.sim"
 __renddecl(1);goto __sw;__l12:__rinner(1);goto __sw;__l13:
-# 70 "../../lib/simset.sim"
+# 70 "../lib/simset.sim"
 __rendclass(1);goto __sw;/* SLUTT CLASS LINK *//* START CLASS HEAD *//* START PROCEDURE FIRST */__l21:
-# 76 "../../lib/simset.sim"
+# 76 "../lib/simset.sim"

-# 78 "../../lib/simset.sim"
+# 78 "../lib/simset.sim"
 ;((__bs217 *)__lb)->er=(((__bp=(__rin(((__bs207 *)__lb->sl)->zzsuc,&__p211SIMSET)?((__bs207 *)__lb->sl)->zzsuc:__NULL))!=__NULL && (__bp->pp->pref[1]!= &__p211SIMSET))?(__dhp)__rerror(__errqual):__bp);__er=((__bs217 *)__lb)->er;__rep();goto __sw;/* SLUTT PROCEDURE FIRST *//* START PROCEDURE LAST */__l22:
-# 80 "../../lib/simset.sim"
+# 80 "../lib/simset.sim"

-# 82 "../../lib/simset.sim"
+# 82 "../lib/simset.sim"
 ;((__bs218 *)__lb)->er=(((__bp=(__rin(((__bs207 *)__lb->sl)->zzpred,&__p211SIMSET)?((__bs207 *)__lb->sl)->zzpred:__NULL))!=__NULL && (__bp->pp->pref[1]!= &__p211SIMSET))?(__dhp)__rerror(__errqual):__bp);__er=((__bs218 *)__lb)->er;__rep();goto __sw;/* SLUTT PROCEDURE LAST *//* START PROCEDURE EMPTY */__l23:
-# 84 "../../lib/simset.sim"
+# 84 "../lib/simset.sim"
 ;(((__bs219 *)__lb)->ec=((((__bs207 *)__lb->sl)->zzsuc==__lb->sl)));__ev.c=((__bs219 *)__lb)->ec;__rep();goto __sw;/* SLUTT PROCEDURE EMPTY *//* START PROCEDURE CARDINAL */__l24:
-# 86 "../../lib/simset.sim"
+# 86 "../lib/simset.sim"

-# 94 "../../lib/simset.sim"
+# 94 "../lib/simset.sim"
 ;((__bs220 *)__lb)->PTR=((__bs207 *)__lb->sl)->zzsuc;
-# 95 "../../lib/simset.sim"
+# 95 "../lib/simset.sim"
 __ll4:;if(!((((__bs220 *)__lb)->PTR!=__lb->sl)))goto __ll5;
-# 96 "../../lib/simset.sim"
+# 96 "../lib/simset.sim"
 ;(((__bs220 *)__lb)->I=((((__bs220 *)__lb)->I+1L)));
-# 97 "../../lib/simset.sim"
+# 97 "../lib/simset.sim"
 ;((__bs220 *)__lb)->PTR=((__bs207 *)((__bp=((__bs220 *)__lb)->PTR)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsuc;
-# 98 "../../lib/simset.sim"
+# 98 "../lib/simset.sim"
 goto __ll4;__ll5:
-# 101 "../../lib/simset.sim"
+# 101 "../lib/simset.sim"
 ;(((__bs220 *)__lb)->ev=(((__bs220 *)__lb)->I));__ev.i=((__bs220 *)__lb)->ev;__rep();goto __sw;/* SLUTT PROCEDURE CARDINAL *//* START PROCEDURE CLEAR */__l25:
-# 104 "../../lib/simset.sim"
+# 104 "../lib/simset.sim"

-# 107 "../../lib/simset.sim"
+# 107 "../lib/simset.sim"
 ;((__bs221 *)__lb)->PTR=((__bs207 *)__lb->sl)->zzsuc;
-# 108 "../../lib/simset.sim"
+# 108 "../lib/simset.sim"
 __ll6:;if(!((((__bs221 *)__lb)->PTR!=__lb->sl)))goto __ll7;
-# 110 "../../lib/simset.sim"
+# 110 "../lib/simset.sim"
 ;((__bs221 *)__lb)->PTRSUC=((__bs207 *)((__bp=((__bs221 *)__lb)->PTR)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsuc;
-# 111 "../../lib/simset.sim"
+# 111 "../lib/simset.sim"
 (((__bs221 *)__lb)->__r1=(((__bs221 *)__lb)->PTR));((__bs207 *)((__bp=((__bs221 *)__lb)->__r1)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsuc=((__bs207 *)((__bp=((__bs221 *)__lb)->PTR)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzpred=__NULL;
-# 112 "../../lib/simset.sim"
+# 112 "../lib/simset.sim"
 ;((__bs221 *)__lb)->PTR=((__bs221 *)__lb)->PTRSUC;
-# 113 "../../lib/simset.sim"
+# 113 "../lib/simset.sim"
 goto __ll6;__ll7:
-# 115 "../../lib/simset.sim"
+# 115 "../lib/simset.sim"
 ;((__bs207 *)__lb->sl)->zzsuc=((__bs207 *)__lb->sl)->zzpred=__lb->sl;__repp();goto __sw;/* SLUTT PROCEDURE CLEAR */__l18:
-# 73 "../../lib/simset.sim"
+# 73 "../lib/simset.sim"
 __renddecl(1);goto __sw;__l19:
-# 118 "../../lib/simset.sim"
+# 118 "../lib/simset.sim"
 ;((__bs207 *)__lb)->zzsuc=((__bs207 *)__lb)->zzpred=__lb;
-# 73 "../../lib/simset.sim"
+# 73 "../lib/simset.sim"
 __rinner(1);goto __sw;__l20:
-# 118 "../../lib/simset.sim"
+# 118 "../lib/simset.sim"
 __rendclass(1);goto __sw;/* SLUTT CLASS HEAD */__l2:
-# 25 "../../lib/simset.sim"
+# 25 "../lib/simset.sim"
 __renddecl(0);goto __sw;__l3:__rinner(0);goto __sw;__l4:
-# 120 "../../lib/simset.sim"
+# 120 "../lib/simset.sim"
 __rendclass(0);goto __sw;/* SLUTT CLASS SIMSET */__ll0:__rbe();__sw:if(__goto.ment!=(void (*)())__m_SIMSET)return;__s:switch(__goto.ent){case 2: goto __l2;
 case 3: goto __l3;
 case 4: goto __l4;
diff -ur ./lib/simulation.c ./lib/simulation.c
--- ./lib/simulation.c	2014-05-18 19:42:40.000000000 -0400
+++ ./lib/simulation.c	2016-03-04 18:23:44.000000000 -0500
@@ -1,5 +1,5 @@
 /*Cim_ccode*/
-#include "../../lib/cim.h"
+#include "../lib/cim.h"
 struct __tt1 {__txt tvar;__th h;char string[27];}
 __tk1SIMULATION={(__textref)&__tk1SIMULATION.h.pp,26,1,1,(__pty)__TEXT,(__dhp)&__tk1SIMULATION.h.pp,__CONSTANT,26,"No\040Evtime\040for\040idle\040process"};
 struct __tt2 {__txt tvar;__th h;char string[11];}
@@ -15,7 +15,7 @@
 struct __tt7 {__txt tvar;__th h;char string[11];}
 __tk7SIMULATION={(__textref)&__tk7SIMULATION.h.pp,10,1,1,(__pty)__TEXT,(__dhp)&__tk7SIMULATION.h.pp,__CONSTANT,10,"SQS:\040Empty"};
 void __m_SIMULATION();
-__map __mapSIMULATION[3]={"../../lib/simulation.sim",0L,1L,
+__map __mapSIMULATION[3]={"../lib/simulation.sim",0L,1L,
 "",-233L,234L,
 "",0L,9223372036854775807L};
 typedef struct /*  */
@@ -351,255 +351,255 @@
 extern __ptyp __p236SIMULATION;__pty   __pl236SIMULATION[1]={&__p236SIMULATION};
 __ptyp __p236SIMULATION={'P',0,3,sizeof(__bs236),22,__m_SIMULATION,0,0,7,0,__rl236SIMULATION,0,__pl236SIMULATION,__NULL};
 void __m_SIMULATION(void){goto __s;
-# 27 "../../lib/simulation.sim"
+# 27 "../lib/simulation.sim"
 __sto= (__dhp)&__blokk205SIMULATION;__rb(&__p205SIMULATION);goto __ll0;/* START CLASS SIMULATION *//* START PROCEDURE CURRENT */__l5:
-# 33 "../../lib/simulation.sim"
+# 33 "../lib/simulation.sim"
 ;((__bs223 *)__lb)->er=((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;__er=((__bs223 *)__lb)->er;__rep();goto __sw;/* SLUTT PROCEDURE CURRENT *//* START PROCEDURE TIME */__l6:
-# 35 "../../lib/simulation.sim"
+# 35 "../lib/simulation.sim"
 ;(((__bs224 *)__lb)->ef=(((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime));__ev.f=((__bs224 *)__lb)->ef;__rep();goto __sw;/* SLUTT PROCEDURE TIME *//* START CLASS PROCESS *//* START PROCEDURE IDLE */__l10:
-# 46 "../../lib/simulation.sim"
+# 46 "../lib/simulation.sim"
 ;(((__bs226 *)__lb)->ec=((((__bs225 *)__lb->sl)->zzsqssuc==__NULL)));__ev.c=((__bs226 *)__lb)->ec;__rep();goto __sw;/* SLUTT PROCEDURE IDLE *//* START PROCEDURE TERMINATED */__l11:
-# 48 "../../lib/simulation.sim"
+# 48 "../lib/simulation.sim"
 ;(((__bs227 *)__lb)->ec=(((__bs225 *)__lb->sl)->zzterminated_process));__ev.c=((__bs227 *)__lb)->ec;__rep();goto __sw;/* SLUTT PROCEDURE TERMINATED *//* START PROCEDURE EVTIME */__l12:
-# 50 "../../lib/simulation.sim"
+# 50 "../lib/simulation.sim"

-# 51 "../../lib/simulation.sim"
+# 51 "../lib/simulation.sim"
 ;if(!((((__bs225 *)__lb->sl)->zzsqssuc==__NULL)))goto __ll2;
-# 52 "../../lib/simulation.sim"
+# 52 "../lib/simulation.sim"
 ;__rterror((__txtvp)&__tk1SIMULATION);goto __ll1;__ll2:;(((__bs228 *)__lb)->ef=(((__bs225 *)__lb->sl)->zzevtime));__ll1:__ev.f=((__bs228 *)__lb)->ef;__rep();goto __sw;/* SLUTT PROCEDURE EVTIME *//* START PROCEDURE NEXTEV */__l13:
-# 54 "../../lib/simulation.sim"
+# 54 "../lib/simulation.sim"

-# 56 "../../lib/simulation.sim"
+# 56 "../lib/simulation.sim"
 ;((__bs229 *)__lb)->er=(((__bp=(((((__bs225 *)__lb->sl)->zzsqssuc==__NULL)||(((__bs225 *)__lb->sl)->zzsqssuc==((__bs222 *)__lb->sl->sl)->zzsqs))?__NULL:((__bs225 *)__lb->sl)->zzsqssuc))!=__NULL && (__bp->pp->pref[2]!= &__p225SIMULATION))?(__dhp)__rerror(__errqual):__bp);__er=((__bs229 *)__lb)->er;__rep();goto __sw;/* SLUTT PROCEDURE NEXTEV */__l7:
-# 37 "../../lib/simulation.sim"
+# 37 "../lib/simulation.sim"
 __renddecl(2);goto __sw;__l8:
-# 58 "../../lib/simulation.sim"
+# 58 "../lib/simulation.sim"
 ;((__bs225 *)__lb)->zzsqssuc=((__bs225 *)__lb)->zzsqspred=__NULL;
-# 60 "../../lib/simulation.sim"
+# 60 "../lib/simulation.sim"
 ;__rdetach(__lb,23,__m_SIMULATION);goto __sw;__l23:;
-# 61 "../../lib/simulation.sim"
+# 61 "../lib/simulation.sim"
 __rinner(2);goto __sw;__l9:
-# 62 "../../lib/simulation.sim"
+# 62 "../lib/simulation.sim"
 ;(((__bs225 *)__lb)->zzterminated_process=(1));
-# 65 "../../lib/simulation.sim"
+# 65 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)__lb)->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs225 *)__lb)->zzsqspred;
-# 66 "../../lib/simulation.sim"
+# 66 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)__lb)->zzsqspred)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs225 *)__lb)->zzsqssuc;
-# 67 "../../lib/simulation.sim"
+# 67 "../lib/simulation.sim"
 ;((__bs225 *)__lb)->zzsqspred=((__bs225 *)__lb)->zzsqssuc=__NULL;
-# 69 "../../lib/simulation.sim"
+# 69 "../lib/simulation.sim"
 ;if(!((((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc==((__bs222 *)__lb->sl)->zzsqs)))goto __ll4;
-# 70 "../../lib/simulation.sim"
+# 70 "../lib/simulation.sim"
 ;__rterror((__txtvp)&__tk2SIMULATION);goto __ll3;__ll4:;__rresume(((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc,24,__m_SIMULATION);goto __sw;__l24:;__ll3:
-# 72 "../../lib/simulation.sim"
+# 72 "../lib/simulation.sim"
 ;__rterror((__txtvp)&__tk3SIMULATION);
-# 73 "../../lib/simulation.sim"
+# 73 "../lib/simulation.sim"
 __rendclass(2);goto __sw;/* SLUTT CLASS PROCESS *//* START PROCEDURE activat */__l14:
-# 75 "../../lib/simulation.sim"
+# 75 "../lib/simulation.sim"
 (((__bp=((__bs230 *)__lb)->X)!=__NULL && (__bp->pp->pref[2]!= &__p225SIMULATION))?(__dhp)__rerror(__errqual):__bp);(((__bp=((__bs230 *)__lb)->Y)!=__NULL && (__bp->pp->pref[2]!= &__p225SIMULATION))?(__dhp)__rerror(__errqual):__bp);
-# 85 "../../lib/simulation.sim"
+# 85 "../lib/simulation.sim"
 ;if(!(((((__bs230 *)__lb)->X!=__NULL)&&((!((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzterminated_process)&&(((__bs230 *)__lb)->REAC||(((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc==__NULL))))))goto __ll5;
-# 87 "../../lib/simulation.sim"
+# 87 "../lib/simulation.sim"
 ;((__bs230 *)__lb)->cur=((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;;(((__bs230 *)__lb)->tm=(((__bs225 *)((__bp=((__bs230 *)__lb)->cur)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime));
-# 89 "../../lib/simulation.sim"
+# 89 "../lib/simulation.sim"
 ;if(!(((unsigned char)((__bs230 *)__lb)->CODE==(unsigned char)1)))goto __ll7;
-# 91 "../../lib/simulation.sim"
+# 91 "../lib/simulation.sim"
 ;if(!((((__bs230 *)__lb)->X==((__bs230 *)__lb)->cur)))goto __ll8;;goto __l25;__ll8:
-# 92 "../../lib/simulation.sim"
+# 92 "../lib/simulation.sim"
 ;(((__bs230 *)__lb)->T=(((__bs230 *)__lb)->tm));;((__bs230 *)__lb)->b=((__bs222 *)__lb->sl)->zzsqs;
-# 93 "../../lib/simulation.sim"
+# 93 "../lib/simulation.sim"
 goto __ll6;__ll7:
-# 94 "../../lib/simulation.sim"
+# 94 "../lib/simulation.sim"
 ;if(!(((unsigned char)((__bs230 *)__lb)->CODE==(unsigned char)2)))goto __ll10;
-# 96 "../../lib/simulation.sim"
+# 96 "../lib/simulation.sim"
 ;if(!((((__bs230 *)__lb)->T<=((__bs230 *)__lb)->tm)))goto __ll11;
-# 97 "../../lib/simulation.sim"
+# 97 "../lib/simulation.sim"
 ;if(!((((__bs230 *)__lb)->PRIO&&(((__bs230 *)__lb)->X==((__bs230 *)__lb)->cur))))goto __ll13;;goto __l25;__ll13:;(((__bs230 *)__lb)->T=(((__bs230 *)__lb)->tm));__ll12:__ll11:
-# 98 "../../lib/simulation.sim"
+# 98 "../lib/simulation.sim"
 goto __ll9;__ll10:
-# 99 "../../lib/simulation.sim"
+# 99 "../lib/simulation.sim"
 ;if(!(((unsigned char)((__bs230 *)__lb)->CODE==(unsigned char)3)))goto __ll15;
-# 101 "../../lib/simulation.sim"
+# 101 "../lib/simulation.sim"
 ;(((__bs230 *)__lb)->T=((((__bs230 *)__lb)->T+((__bs230 *)__lb)->tm)));
-# 102 "../../lib/simulation.sim"
+# 102 "../lib/simulation.sim"
 ;if(!((((__bs230 *)__lb)->T<=((__bs230 *)__lb)->tm)))goto __ll16;
-# 103 "../../lib/simulation.sim"
+# 103 "../lib/simulation.sim"
 ;if(!((((__bs230 *)__lb)->PRIO&&(((__bs230 *)__lb)->X==((__bs230 *)__lb)->cur))))goto __ll18;;goto __l25;__ll18:;(((__bs230 *)__lb)->T=(((__bs230 *)__lb)->tm));__ll17:__ll16:
-# 104 "../../lib/simulation.sim"
+# 104 "../lib/simulation.sim"
 goto __ll14;__ll15:
-# 107 "../../lib/simulation.sim"
+# 107 "../lib/simulation.sim"
 ;if(!(((((__bs230 *)__lb)->Y==__NULL)||(((__bs225 *)((__bp=((__bs230 *)__lb)->Y)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc==__NULL))))goto __ll19;
-# 109 "../../lib/simulation.sim"
+# 109 "../lib/simulation.sim"
 ;if(!((((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc!=__NULL)))goto __ll20;
-# 111 "../../lib/simulation.sim"
+# 111 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;
-# 112 "../../lib/simulation.sim"
+# 112 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 113 "../../lib/simulation.sim"
+# 113 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=__NULL;;((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=__NULL;
-# 114 "../../lib/simulation.sim"
+# 114 "../lib/simulation.sim"
 __ll20:
-# 116 "../../lib/simulation.sim"
+# 116 "../lib/simulation.sim"
 ;if(!((((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc==((__bs222 *)__lb->sl)->zzsqs)))goto __ll21;;__rterror((__txtvp)&__tk4SIMULATION);__ll21:
-# 117 "../../lib/simulation.sim"
+# 117 "../lib/simulation.sim"
 ;goto __l25;__ll19:
-# 120 "../../lib/simulation.sim"
+# 120 "../lib/simulation.sim"
 ;if(!((((__bs230 *)__lb)->X==((__bs230 *)__lb)->Y)))goto __ll22;;goto __l25;__ll22:
-# 122 "../../lib/simulation.sim"
+# 122 "../lib/simulation.sim"
 ;(((__bs230 *)__lb)->T=(((__bs225 *)((__bp=((__bs230 *)__lb)->Y)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime));
-# 124 "../../lib/simulation.sim"
+# 124 "../lib/simulation.sim"
 ;if(!(((unsigned char)((__bs230 *)__lb)->CODE==(unsigned char)4)))goto __ll24;;((__bs230 *)__lb)->b=((__bs225 *)((__bp=((__bs230 *)__lb)->Y)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;goto __ll23;__ll24:;((__bs230 *)__lb)->b=((__bs230 *)__lb)->Y;__ll23:
-# 125 "../../lib/simulation.sim"
+# 125 "../lib/simulation.sim"
 __ll14:__ll9:__ll6:
-# 127 "../../lib/simulation.sim"
+# 127 "../lib/simulation.sim"
 ;if(!((((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc!=__NULL)))goto __ll25;
-# 129 "../../lib/simulation.sim"
+# 129 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;
-# 130 "../../lib/simulation.sim"
+# 130 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 131 "../../lib/simulation.sim"
+# 131 "../lib/simulation.sim"
 __ll25:
-# 133 "../../lib/simulation.sim"
+# 133 "../lib/simulation.sim"
 ;if(!((((__bs230 *)__lb)->b==__NULL)))goto __ll26;
-# 135 "../../lib/simulation.sim"
+# 135 "../lib/simulation.sim"
 ;((__bs230 *)__lb)->b=((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;
-# 136 "../../lib/simulation.sim"
+# 136 "../lib/simulation.sim"
 __ll27:;if(!((((__bs225 *)((__bp=((__bs230 *)__lb)->b)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime>((__bs230 *)__lb)->T)))goto __ll28;;((__bs230 *)__lb)->b=((__bs225 *)((__bp=((__bs230 *)__lb)->b)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;goto __ll27;__ll28:
-# 137 "../../lib/simulation.sim"
+# 137 "../lib/simulation.sim"
 ;if(!(((__bs230 *)__lb)->PRIO))goto __ll29;
-# 138 "../../lib/simulation.sim"
+# 138 "../lib/simulation.sim"
 __ll30:;if(!((((__bs225 *)((__bp=((__bs230 *)__lb)->b)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime==((__bs230 *)__lb)->T)))goto __ll31;;((__bs230 *)__lb)->b=((__bs225 *)((__bp=((__bs230 *)__lb)->b)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;goto __ll30;__ll31:__ll29:
-# 139 "../../lib/simulation.sim"
+# 139 "../lib/simulation.sim"
 __ll26:
-# 141 "../../lib/simulation.sim"
+# 141 "../lib/simulation.sim"
 ;(((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime=(((__bs230 *)__lb)->T));
-# 142 "../../lib/simulation.sim"
+# 142 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs230 *)__lb)->b;;((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs225 *)((__bp=((__bs230 *)__lb)->b)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 143 "../../lib/simulation.sim"
+# 143 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs230 *)__lb)->b)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs230 *)__lb)->X;;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs230 *)__lb)->X)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs230 *)__lb)->X;
-# 145 "../../lib/simulation.sim"
+# 145 "../lib/simulation.sim"
 ;if(!((((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc!=((__bs230 *)__lb)->cur)))goto __ll32;;__rresume(((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc,26,__m_SIMULATION);goto __sw;__l26:;__ll32:
-# 146 "../../lib/simulation.sim"
+# 146 "../lib/simulation.sim"
 __ll5:
-# 147 "../../lib/simulation.sim"
+# 147 "../lib/simulation.sim"
 /*exit_230*/__l25:
-# 148 "../../lib/simulation.sim"
+# 148 "../lib/simulation.sim"
 __repp();goto __sw;/* SLUTT PROCEDURE activat *//* START PROCEDURE HOLD */__l15:
-# 150 "../../lib/simulation.sim"
+# 150 "../lib/simulation.sim"

-# 153 "../../lib/simulation.sim"
+# 153 "../lib/simulation.sim"
 ;((__bs231 *)__lb)->p=((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 154 "../../lib/simulation.sim"
+# 154 "../lib/simulation.sim"
 ;if(!((((__bs231 *)__lb)->t> 0.0000000000000000e+00)))goto __ll33;;(((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime=((((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime+((__bs231 *)__lb)->t)));__ll33:
-# 155 "../../lib/simulation.sim"
+# 155 "../lib/simulation.sim"
 ;(((__bs231 *)__lb)->t=(((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime));
-# 156 "../../lib/simulation.sim"
+# 156 "../lib/simulation.sim"
 ;if(!(((((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc!=((__bs222 *)__lb->sl)->zzsqs)&&(((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime<=((__bs231 *)__lb)->t))))goto __ll34;
-# 158 "../../lib/simulation.sim"
+# 158 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;
-# 159 "../../lib/simulation.sim"
+# 159 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 161 "../../lib/simulation.sim"
+# 161 "../lib/simulation.sim"
 ;((__bs231 *)__lb)->q=((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;
-# 162 "../../lib/simulation.sim"
+# 162 "../lib/simulation.sim"
 __ll35:;if(!((((__bs225 *)((__bp=((__bs231 *)__lb)->q)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime>((__bs231 *)__lb)->t)))goto __ll36;;((__bs231 *)__lb)->q=((__bs225 *)((__bp=((__bs231 *)__lb)->q)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;goto __ll35;__ll36:
-# 164 "../../lib/simulation.sim"
+# 164 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs231 *)__lb)->q;;((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs225 *)((__bp=((__bs231 *)__lb)->q)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 165 "../../lib/simulation.sim"
+# 165 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs231 *)__lb)->q)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs231 *)__lb)->p;;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs231 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs231 *)__lb)->p;
-# 167 "../../lib/simulation.sim"
+# 167 "../lib/simulation.sim"
 ;__rresume(((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc,27,__m_SIMULATION);goto __sw;__l27:;
-# 168 "../../lib/simulation.sim"
+# 168 "../lib/simulation.sim"
 __ll34:
-# 169 "../../lib/simulation.sim"
+# 169 "../lib/simulation.sim"
 __repp();goto __sw;/* SLUTT PROCEDURE HOLD *//* START PROCEDURE PASSIVATE */__l16:
-# 171 "../../lib/simulation.sim"
+# 171 "../lib/simulation.sim"

-# 173 "../../lib/simulation.sim"
+# 173 "../lib/simulation.sim"
 ;((__bs232 *)__lb)->p=((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 174 "../../lib/simulation.sim"
+# 174 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs232 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs225 *)((__bp=((__bs232 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;
-# 175 "../../lib/simulation.sim"
+# 175 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs232 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs225 *)((__bp=((__bs232 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 176 "../../lib/simulation.sim"
+# 176 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs232 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=__NULL;;((__bs225 *)((__bp=((__bs232 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=__NULL;
-# 178 "../../lib/simulation.sim"
+# 178 "../lib/simulation.sim"
 ;if(!((((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc==((__bs222 *)__lb->sl)->zzsqs)))goto __ll38;
-# 179 "../../lib/simulation.sim"
+# 179 "../lib/simulation.sim"
 ;__rterror((__txtvp)&__tk5SIMULATION);goto __ll37;__ll38:;__rresume(((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc,28,__m_SIMULATION);goto __sw;__l28:;__ll37:
-# 180 "../../lib/simulation.sim"
+# 180 "../lib/simulation.sim"
 __repp();goto __sw;/* SLUTT PROCEDURE PASSIVATE *//* START PROCEDURE WAIT */__l17:
-# 182 "../../lib/simulation.sim"
+# 182 "../lib/simulation.sim"
 (((__bp=((__bs233 *)__lb)->S)!=__NULL && (__bp->pp->pref[1]!= &__p216SIMSET))?(__dhp)__rerror(__errqual):__bp);
-# 184 "../../lib/simulation.sim"
+# 184 "../lib/simulation.sim"
 ;((__bs233 *)__lb)->p=((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 185 "../../lib/simulation.sim"
+# 185 "../lib/simulation.sim"
 __sl=((__bp=((__bs233 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp);__rcpp(&__p215SIMSET);((__bs215 *)__pb)->S=((__bs233 *)__lb)->S;__rcpb(29,__m_SIMULATION);return;__l29:;;
-# 187 "../../lib/simulation.sim"
+# 187 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs233 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs225 *)((__bp=((__bs233 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;
-# 188 "../../lib/simulation.sim"
+# 188 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs233 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs225 *)((__bp=((__bs233 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 189 "../../lib/simulation.sim"
+# 189 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs233 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=__NULL;;((__bs225 *)((__bp=((__bs233 *)__lb)->p)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=__NULL;
-# 191 "../../lib/simulation.sim"
+# 191 "../lib/simulation.sim"
 ;if(!((((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc==((__bs222 *)__lb->sl)->zzsqs)))goto __ll40;
-# 192 "../../lib/simulation.sim"
+# 192 "../lib/simulation.sim"
 ;__rterror((__txtvp)&__tk6SIMULATION);goto __ll39;__ll40:;__rresume(((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc,30,__m_SIMULATION);goto __sw;__l30:;__ll39:
-# 193 "../../lib/simulation.sim"
+# 193 "../lib/simulation.sim"
 __repp();goto __sw;/* SLUTT PROCEDURE WAIT *//* START PROCEDURE CANCEL */__l18:
-# 195 "../../lib/simulation.sim"
+# 195 "../lib/simulation.sim"
 (((__bp=((__bs234 *)__lb)->x)!=__NULL && (__bp->pp->pref[2]!= &__p225SIMULATION))?(__dhp)__rerror(__errqual):__bp);
-# 198 "../../lib/simulation.sim"
+# 198 "../lib/simulation.sim"
 ;if(!(((((__bs234 *)__lb)->x!=__NULL)&&(((__bs225 *)((__bp=((__bs234 *)__lb)->x)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc!=__NULL))))goto __ll41;
-# 200 "../../lib/simulation.sim"
+# 200 "../lib/simulation.sim"
 ;((__bs234 *)__lb)->cur=((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 201 "../../lib/simulation.sim"
+# 201 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs234 *)__lb)->x)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs225 *)((__bp=((__bs234 *)__lb)->x)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred;
-# 202 "../../lib/simulation.sim"
+# 202 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs225 *)((__bp=((__bs234 *)__lb)->x)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs225 *)((__bp=((__bs234 *)__lb)->x)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc;
-# 203 "../../lib/simulation.sim"
+# 203 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs234 *)__lb)->x)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=__NULL;;((__bs225 *)((__bp=((__bs234 *)__lb)->x)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=__NULL;
-# 205 "../../lib/simulation.sim"
+# 205 "../lib/simulation.sim"
 ;if(!((((__bs234 *)__lb)->x==((__bs234 *)__lb)->cur)))goto __ll42;
-# 207 "../../lib/simulation.sim"
+# 207 "../lib/simulation.sim"
 ;if(!((((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc==((__bs222 *)__lb->sl)->zzsqs)))goto __ll44;
-# 208 "../../lib/simulation.sim"
+# 208 "../lib/simulation.sim"
 ;__rterror((__txtvp)&__tk7SIMULATION);goto __ll43;__ll44:;__rresume(((__bs225 *)((__bp=((__bs222 *)__lb->sl)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc,31,__m_SIMULATION);goto __sw;__l31:;__ll43:
-# 209 "../../lib/simulation.sim"
+# 209 "../lib/simulation.sim"
 __ll42:
-# 210 "../../lib/simulation.sim"
+# 210 "../lib/simulation.sim"
 __ll41:
-# 211 "../../lib/simulation.sim"
+# 211 "../lib/simulation.sim"
 __repp();goto __sw;/* SLUTT PROCEDURE CANCEL *//* START CLASS zzmain_program */__l19:
-# 213 "../../lib/simulation.sim"
+# 213 "../lib/simulation.sim"
 __renddecl(3);goto __sw;__l20:
-# 215 "../../lib/simulation.sim"
+# 215 "../lib/simulation.sim"
 __ll45:;if(!(1))goto __ll46;
-# 216 "../../lib/simulation.sim"
+# 216 "../lib/simulation.sim"
 ;__rdetach(__lb,32,__m_SIMULATION);goto __sw;__l32:;goto __ll45;__ll46:
-# 213 "../../lib/simulation.sim"
+# 213 "../lib/simulation.sim"
 __rinner(3);goto __sw;__l21:
-# 216 "../../lib/simulation.sim"
+# 216 "../lib/simulation.sim"
 __rendclass(3);goto __sw;/* SLUTT CLASS zzmain_program *//* START PROCEDURE ACCUM */__l22:
-# 218 "../../lib/simulation.sim"
+# 218 "../lib/simulation.sim"

-# 221 "../../lib/simulation.sim"
+# 221 "../lib/simulation.sim"
 if(__rgetsa(&((__bs236 *)__lb)->A,0L,33,__m_SIMULATION))goto __sw;__l33:;((__bs236 *)__lb)->__r1= __er;((__bs236 *)__lb)->__v1.i= __ev.i;if(__rgetav(__TREAL,&((__bs236 *)__lb)->A,0L,34,__m_SIMULATION))goto __sw;__l34:;((__bs236 *)__lb)->__v2.f= __ev.f;if(__rgetav(__TREAL,&((__bs236 *)__lb)->C,0L,35,__m_SIMULATION))goto __sw;__l35:;((__bs236 *)__lb)->__v3.f= __ev.f;__sl=__lb->sl;__rcp(&__p224SIMULATION,0L);__rcpb(36,__m_SIMULATION);goto __sw;__l36:;((__bs236 *)__lb)->__v4.f= __ev.f;if(__rgetav(__TREAL,&((__bs236 *)__lb)->B,0L,37,__m_SIMULATION))goto __sw;__l37:;((__bs236 *)__lb)->__v5.f= __ev.f;(__ev.f=((((__bs236 *)__lb)->__v2.f+(((__bs236 *)__lb)->__v3.f*(((__bs236 *)__lb)->__v4.f-((__bs236 *)__lb)->__v5.f)))));if((__nvp= &((__bs236 *)__lb)->A)->conv==__NOCONV) *(double *)(((char *)((__bs236 *)__lb)->__r1)+((__bs236 *)__lb)->__v1.i)=__ev.f;else if(__nvp->conv==__INTREAL) *(long *)(((char *)((__bs236 *)__lb)->__r1)+((__bs236 *)__lb)->__v1.i)=__ev.f;else  *(double *)(((char *)((__bs236 *)__lb)->__r1)+((__bs236 *)__lb)->__v1.i)=__rintrea(__ev.f);if(__rgetsa(&((__bs236 *)__lb)->B,0L,38,__m_SIMULATION))goto __sw;__l38:;((__bs236 *)__lb)->__r1= __er;((__bs236 *)__lb)->__v1.i= __ev.i;__sl=__lb->sl;__rcp(&__p224SIMULATION,0L);__rcpb(39,__m_SIMULATION);goto __sw;__l39:;((__bs236 *)__lb)->__v2.f= __ev.f;(__ev.f=(((__bs236 *)__lb)->__v2.f));if((__nvp= &((__bs236 *)__lb)->B)->conv==__NOCONV) *(double *)(((char *)((__bs236 *)__lb)->__r1)+((__bs236 *)__lb)->__v1.i)=__ev.f;else if(__nvp->conv==__INTREAL) *(long *)(((char *)((__bs236 *)__lb)->__r1)+((__bs236 *)__lb)->__v1.i)=__ev.f;else  *(double *)(((char *)((__bs236 *)__lb)->__r1)+((__bs236 *)__lb)->__v1.i)=__rintrea(__ev.f);if(__rgetsa(&((__bs236 *)__lb)->C,0L,40,__m_SIMULATION))goto __sw;__l40:;((__bs236 *)__lb)->__r1= __er;((__bs236 *)__lb)->__v1.i= __ev.i;if(__rgetav(__TREAL,&((__bs236 *)__lb)->C,0L,41,__m_SIMULATION))goto __sw;__l41:;((__bs236 *)__lb)->__v2.f= __ev.f;(__ev.f=((((__bs236 *)__lb)->__v2.f+((__bs236 *)__lb)->D)));if((__nvp= &((__bs236 *)__lb)->C)->conv==__NOCONV) *(double *)(((char *)((__bs236 *)__lb)->__r1)+((__bs236 *)__lb)->__v1.i)=__ev.f;else if(__nvp->conv==__INTREAL) *(long *)(((char *)((__bs236 *)__lb)->__r1)+((__bs236 *)__lb)->__v1.i)=__ev.f;else  *(double *)(((char *)((__bs236 *)__lb)->__r1)+((__bs236 *)__lb)->__v1.i)=__rintrea(__ev.f);
-# 222 "../../lib/simulation.sim"
+# 222 "../lib/simulation.sim"
 __repp();goto __sw;/* SLUTT PROCEDURE ACCUM */__l2:
-# 27 "../../lib/simulation.sim"
+# 27 "../lib/simulation.sim"
 __renddecl(1);goto __sw;__l3:
-# 224 "../../lib/simulation.sim"
+# 224 "../lib/simulation.sim"
 __sl=__lb;__rcp(&__p225SIMULATION,0L);__rccb(42,__m_SIMULATION);goto __sw;__l42:;((__bs222 *)__lb)->__r1= __er;((__bs222 *)__lb)->zzsqs=((__bs222 *)__lb)->__r1;;(((__bs225 *)((__bp=((__bs222 *)__lb)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzevtime=( -1.0000000000000000e+00));
-# 226 "../../lib/simulation.sim"
+# 226 "../lib/simulation.sim"
 __sl=__lb;__rcp(&__p235SIMULATION,0L);__rccb(43,__m_SIMULATION);goto __sw;__l43:;((__bs222 *)__lb)->__r1= __er;((__bs222 *)__lb)->MAIN=((__bs222 *)__lb)->__r1;
-# 227 "../../lib/simulation.sim"
+# 227 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs222 *)__lb)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs222 *)__lb)->MAIN;;((__bs225 *)((__bp=((__bs222 *)__lb)->zzsqs)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs222 *)__lb)->MAIN;
-# 228 "../../lib/simulation.sim"
+# 228 "../lib/simulation.sim"
 ;((__bs225 *)((__bp=((__bs222 *)__lb)->MAIN)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqssuc=((__bs222 *)__lb)->zzsqs;;((__bs225 *)((__bp=((__bs222 *)__lb)->MAIN)==__NULL?(__dhp)__rerror(__errnone):__bp))->zzsqspred=((__bs222 *)__lb)->zzsqs;
-# 27 "../../lib/simulation.sim"
+# 27 "../lib/simulation.sim"
 __rinner(1);goto __sw;__l4:
-# 230 "../../lib/simulation.sim"
+# 230 "../lib/simulation.sim"
 __rendclass(1);goto __sw;/* SLUTT CLASS SIMULATION */__ll0:__rbe();__sw:if(__goto.ment!=(void (*)())__m_SIMULATION)return;__s:switch(__goto.ent){case 2: goto __l2;
 case 3: goto __l3;
 case 4: goto __l4;
diff -ur ./src/expchecker.c ./src/expchecker.c
--- ./src/expchecker.c	2013-09-30 22:52:25.000000000 -0400
+++ ./src/expchecker.c	2016-03-04 18:22:19.000000000 -0500
@@ -230,7 +230,7 @@
 /******************************************************************************
                                                                ARGUMENTERROR */

-static argumenterror (int melding, exp_t *re)
+static void argumenterror (int melding, exp_t *re)
 {
   int i = 1;
   if (TYPE == TERROR)
diff -ur ./src/extspec.c ./src/extspec.c
--- ./src/extspec.c	2013-09-30 22:52:25.000000000 -0400
+++ ./src/extspec.c	2016-03-04 18:22:03.000000000 -0500
@@ -565,7 +565,7 @@
 /******************************************************************************
                                                               WRITE_DECL_MIF */

-static write_decl_mif (FILE *f, decl_t *rd, int level)
+static void write_decl_mif (FILE *f, decl_t *rd, int level)
 {
   if (rd->kind == KBLOKK || rd->kind == KPRBLK || rd->kind == KFOR ||
       rd->kind == KINSP) return;
diff -ur ./src/strgen.c ./src/strgen.c
--- ./src/strgen.c	2013-09-30 22:52:25.000000000 -0400
+++ ./src/strgen.c	2016-03-04 18:21:39.000000000 -0500
@@ -294,7 +294,7 @@
 /******************************************************************************
                                                         BLOCKSTRUCTURE       */

-static blockstructure (block_t *rb)
+static void blockstructure (block_t *rb)
 {
   int i;
   decl_t *rd;

