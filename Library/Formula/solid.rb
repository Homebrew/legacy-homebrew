class Solid < Formula
  homepage "http://www.dtecta.com/"
  url "http://www.dtecta.com/files/solid-3.5.6.tgz"
  sha1 "bd0afef7842f826c270cff32fc23994aec0b0d65"

  deprecated_option "enable-doubles" => "with-doubles"
  deprecated_option "enable-tracer" => "with-tracer"

  option "with-doubles", "Use internal double precision floats"
  option "with-tracer", "Use rounding error tracer"

  # This patch fixes a broken build on clang-600.0.56.
  # Was reported to bugs@dtecta.com (since it also applies to solid-3.5.6)
  patch :DATA

  def install
    args = ["--disable-dependency-tracking",
            "--disable-debug",
            "--prefix=#{prefix}",
            "--infodir=#{info}"]
    args << "--enable-doubles" if build.with? "doubles"
    args << "--enable-tracer" if build.with? "tracer"

    system "./configure", *args

    # exclude the examples from compiling!
    # the examples do not compile because the include statements
    # for the GLUT library are not platform independent
    inreplace "Makefile", " examples ", " "

    system "make", "install"
  end
end

__END__
diff --git a/include/MT/Quaternion.h b/include/MT/Quaternion.h
index 3726b4f..3393697 100644
--- a/include/MT/Quaternion.h
+++ b/include/MT/Quaternion.h
@@ -154,7 +154,7 @@ namespace MT {

		Quaternion<Scalar> inverse() const
		{
-			return conjugate / length2();
+			return conjugate() / length2();
		}

		Quaternion<Scalar> slerp(const Quaternion<Scalar>& q, const Scalar& t) const
diff --git a/src/complex/DT_CBox.h b/src/complex/DT_CBox.h
index 7fc7c5d..16ce972 100644
--- a/src/complex/DT_CBox.h
+++ b/src/complex/DT_CBox.h
@@ -131,4 +131,6 @@ inline DT_CBox operator-(const DT_CBox& b1, const DT_CBox& b2)
                    b1.getExtent() + b2.getExtent());
 }

+inline DT_CBox computeCBox(MT_Scalar margin, const MT_Transform& xform);
+
 #endif
