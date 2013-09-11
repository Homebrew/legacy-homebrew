require 'formula'

class Ddd < Formula
  homepage 'http://www.gnu.org/s/ddd/'
  url 'http://ftpmirror.gnu.org/ddd/ddd-3.3.12.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ddd/ddd-3.3.12.tar.gz'
  sha1 'b91d2dfb1145af409138bd34517a898341724e56'

  depends_on 'lesstif'
  depends_on :x11

  def patches; DATA; end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-builtin-app-defaults",
                          "--enable-builtin-manual",
                          "--prefix=#{prefix}"

    # From MacPorts:
    # make will build the executable "ddd" and the X resource file "Ddd" in the same directory,
    # as HFS+ is case-insensitive by default, this will loosely FAIL
    system "make EXEEXT=exe"

    ENV.deparallelize
    system "make install EXEEXT=exe"

    mv bin/'dddexe', bin/'ddd'
  end
end

__END__
diff --git a/ddd/VSLDefList.C b/ddd/VSLDefList.C
index 55c1778..3dfc6a7 100644
--- a/ddd/VSLDefList.C
+++ b/ddd/VSLDefList.C
@@ -60,7 +60,7 @@ const Box *VSLDefList::eval(Box *arg) const
     {
	std::ostringstream s;
	s << *arg;
-	VSLLib::eval_error("no suiting definition for " + f_name() + s);
+	VSLLib::eval_error("no suiting definition for " + f_name() + s.str().c_str());
     }

     return d ? d->eval(arg) : 0;
