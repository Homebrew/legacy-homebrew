require 'formula'

class Ssreflect < Formula
  homepage 'http://www.msr-inria.inria.fr/Projects/math-components'
  url 'http://www.msr-inria.inria.fr/Projects/math-components/ssreflect-1.4-coq8.4.tar.gz'
  version '1.4'
  sha1 'c9e678a362973b202a5d90d2abf6436fa1ab4dcf'

  depends_on 'objective-caml'
  depends_on 'coq'

  option 'with-doc', 'Install HTML documents'
  option 'with-static', 'Build with static linking'

  def patches
    # Fix an ill-formatted ocamldoc comment.
    DATA
  end

  def install
    ENV.j1

    # Enable static linking.
    if build.include? 'with-static'
      inreplace 'Make' do |s|
        s.gsub! /#\-custom/, '-custom'
        s.gsub! /#SSRCOQ/, 'SSRCOQ'
      end
    end

    args = ["COQBIN=#{HOMEBREW_PREFIX}/bin/",
            "COQLIBINSTALL=lib/coq/user-contrib",
            "COQDOCINSTALL=share/doc",
            "DSTROOT=#{prefix}/"]
    system "make", *args
    system "make", "install", *args
    if build.include? 'with-doc'
      system "make", "-f", "Makefile.coq", "html", *args
      system "make", "-f", "Makefile.coq", "mlihtml", *args
      system "make", "-f", "Makefile.coq", "install-doc", *args
    end
    bin.install 'bin/ssrcoq.byte', 'bin/ssrcoq' if build.include? 'with-static'
    (share/'ssreflect').install "pg-ssr.el"
  end

end


__END__
diff --git a/src/ssrmatching.mli b/src/ssrmatching.mli
index fd2e835..1d9d15b 100644
--- a/src/ssrmatching.mli
+++ b/src/ssrmatching.mli
@@ -77,7 +77,7 @@ val interp_cpattern :
     pattern

 (** The set of occurrences to be matched. The boolean is set to true
- *  to signal the complement of this set (i.e. {-1 3}) *)
+ *  to signal the complement of this set (i.e. \{-1 3\}) *)
 type occ = (bool * int list) option

 (** Substitution function. The [int] argument is the number of binders
