class Yap < Formula
  desc "Prolog compiler designed for performance and extensibility"
  homepage "https://www.dcc.fc.up.pt/~vsc/Yap/index.html"
  url "https://www.dcc.fc.up.pt/~vsc/Yap/yap-6.2.2.tar.gz"
  sha256 "f15f8382104443319a5883eafce5f52f4143b526c7f1cd88d19c1f63fc06d750"

  devel do
    url "https://www.dcc.fc.up.pt/~vsc/Yap/yap-6.3.3.tar.gz"
    sha256 "aee3b449b1669af07a8291ce6e7fb0a9b35e1343e2ab96fadb1a37552397fa78"
  end

  depends_on "gmp"
  depends_on "readline"
  depends_on "homebrew/versions/gcc49"
  depends_on :java => "1.8+"

  fails_with :clang do
    cause "uses variable-length arrays in structs, which will never be supported by clang"
  end

  stable do
    # http://permalink.gmane.org/gmane.comp.ai.prolog.yap.general/1790
    patch :DATA
  end

  def install
    # don't fail on Javadoc errors
    inreplace "packages/jpl/src/java/Makefile.in", '"@JAVADOC@"',
      "#{ENV["JAVA_HOME"]}/bin/javadoc -Xdoclint:none"

    ENV["CC"] = "#{Formula["homebrew/versions/gcc49"].bin}/gcc-4.9"
    system "./configure", "--enable-tabling",
                          "--enable-depth-limit",
                          "--enable-coroutining",
                          "--enable-threads",
                          "--enable-pthread-locking",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-java=#{ENV["JAVA_HOME"]}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    libexec.install lib/"jpl.jar"
  end

  test do
    system "#{bin}/yap", "-dump-runtime-variables"
  end
end

__END__
diff --git a/packages/swi-minisat2/C/Solver.C b/packages/swi-minisat2/C/Solver.C
index 2de3e6d..1bcdbff 100644
--- a/packages/swi-minisat2/C/Solver.C
+++ b/packages/swi-minisat2/C/Solver.C
@@ -120,7 +120,7 @@ bool Solver::addClause(vec<Lit>& ps)
         uncheckedEnqueue(ps[0]);
         return ok = (propagate() == NULL);
     }else{
-        Clause* c = Clause_new(ps, false);
+        Clause* c = Clause::Clause_new(ps, false);
         clauses.push(c);
         attachClause(*c);
     }
@@ -599,7 +599,7 @@ lbool Solver::search(int nof_conflicts, int nof_learnts)
             if (learnt_clause.size() == 1){
                 uncheckedEnqueue(learnt_clause[0]);
             }else{
-                Clause* c = Clause_new(learnt_clause, true);
+                Clause* c = Clause::Clause_new(learnt_clause, true);
                 learnts.push(c);
                 attachClause(*c);
                 claBumpActivity(*c);
diff --git a/packages/swi-minisat2/C/SolverTypes.h b/packages/swi-minisat2/C/SolverTypes.h
index 47e3023..919b60b 100644
--- a/packages/swi-minisat2/C/SolverTypes.h
+++ b/packages/swi-minisat2/C/SolverTypes.h
@@ -119,7 +119,7 @@ public:
 
     // -- use this function instead:
     template<class V>
-    friend Clause* Clause_new(const V& ps, bool learnt = false) {
+    static Clause* Clause_new(const V& ps, bool learnt = false) {
         assert(sizeof(Lit)      == sizeof(uint32_t));
         assert(sizeof(float)    == sizeof(uint32_t));
         void* mem = malloc(sizeof(Clause) + sizeof(uint32_t)*(ps.size()));
