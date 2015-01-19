require 'formula'

class Aplus < Formula
  homepage 'http://www.aplusdev.org/'
  url 'http://mirrors.kernel.org/debian/pool/main/a/aplus-fsf/aplus-fsf_4.22.1.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/a/aplus-fsf/aplus-fsf_4.22.1.orig.tar.gz'
  sha1 'e757cc7654cf35dba15a6a5d6cac5320146558fc'

  # Fix the missing CoreServices include (via Fink version of aplus)
  # Fix C++ syntax errors for clang
  patch :DATA

  def install
    # replace placeholder w/ actual prefix
    ["src/lisp.0/aplus.el", "src/lisp.1/aplus.el"].each do |path|
      chmod 0644, path
      inreplace path, "/usr/local/aplus-fsf-4.20", prefix
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # make install breaks with -j option
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    This package contains a custom APL font; it doesn't display APL characters
    using the usual Unicode codepoints.  Install it by running
      open #{opt_prefix}/fonts/TrueType/KAPL.TTF
    and clicking on the "Install Font" button.
    EOS
  end
end


__END__
--- a/src/AplusGUI/AplusApplication.C	2010-11-28 17:06:58.000000000 -0800
+++ b/src/AplusGUI/AplusApplication.C	2010-11-28 17:06:31.000000000 -0800
@@ -5,6 +5,7 @@
 //
 //
 ///////////////////////////////////////////////////////////////////////////////
+#include <CoreServices/CoreServices.h>
 #include <MSGUI/MSTextField.H>
 #include <MSGUI/MSWidget.H>
 #include <MSIPC/MSTv.H>
diff --git a/src/MSTypes/MSBuiltinTypeVectorInlines.C b/src/MSTypes/MSBuiltinTypeVectorInlines.C
index 051f4e9..9be8070 100644
--- a/src/MSTypes/MSBuiltinTypeVectorInlines.C
+++ b/src/MSTypes/MSBuiltinTypeVectorInlines.C
@@ -77,7 +77,7 @@ INLINELINKAGE MSBuiltinVector<Type> MSBuiltinVector<Type>::operator[] (const MSI
 template <class Type>
 INLINELINKAGE MSBuiltinVector<Type> MSBuiltinVector<Type>::operator[] (const MSBinaryVector & bVect_) const
 {
-  return compress (*this, bVect_);
+  return this->compress (*this, bVect_);
 }
 
 
diff --git a/src/MSTypes/MSFloatMatrix.H b/src/MSTypes/MSFloatMatrix.H
index b8545bc..1bb6351 100644
--- a/src/MSTypes/MSFloatMatrix.H
+++ b/src/MSTypes/MSFloatMatrix.H
@@ -27,7 +27,7 @@ template<class Type> class MSTypeVector;
 template<class Type> class MSMatrixSTypePick; // MSTypeMatrix indexed by an unsigned int
 
 #if !defined(MS_NO_PREDECLARE_SPECIALIZATION)
-class MSMatrixSTypePick<double>; 
+template<> class MSMatrixSTypePick<double>;
 #endif
 
 
diff --git a/src/MSTypes/MSObjectTypeVectorInlines.C b/src/MSTypes/MSObjectTypeVectorInlines.C
index d5d6aa4..43fb49e 100644
--- a/src/MSTypes/MSObjectTypeVectorInlines.C
+++ b/src/MSTypes/MSObjectTypeVectorInlines.C
@@ -87,7 +87,7 @@ INLINELINKAGE MSObjectVector<Type> MSObjectVector<Type>::operator[] (const MSInd
 template <class Type>
 INLINELINKAGE MSObjectVector<Type> MSObjectVector<Type>::operator[] (const MSBinaryVector & bVect_) const
 {
-  return compress (*this, bVect_);
+  return this->compress (*this, bVect_);
 }
 
 
diff --git a/src/MSTypes/MSObservableTree.C b/src/MSTypes/MSObservableTree.C
index 5fb769b..0c2e442 100644
--- a/src/MSTypes/MSObservableTree.C
+++ b/src/MSTypes/MSObservableTree.C
@@ -94,7 +94,7 @@ template <class Element>
 void MSObservableTree<Element>::removeSubtree(const MSTabularTreeCursor<Element>& cursor_)
 {
   MSTabularTreeCursor<Element> cursor2(cursor_);
-  unsigned long pos=position(cursor2);
+  unsigned long pos=this->position(cursor2);
   cursor2.setToParent();
   MSTabularTree<Element>::removeSubtree(cursor_);
   if (cursor2.isValid()) changed(cursor2,pos,MSObservableTreeDelete);
@@ -162,7 +162,7 @@ template <class Element>
 void MSObservableTree<Element>::replaceAt(MSTabularTreeCursor<Element> const& cursor_,Element const& element_)
 {
   MSTabularTree<Element>::replaceAt(cursor_,element_);
-  changed(cursor_,position(cursor_),MSObservableTreeAssign);
+  changed(cursor_,this->position(cursor_),MSObservableTreeAssign);
 }
 
 template <class Element>
@@ -170,10 +170,10 @@ void MSObservableTree<Element>::replaceAt(MSTabularTreeCursor<Element> const& cu
 {
   if (&tree_!=this)
    {
-     if (isRoot(cursor_)) copy(tree_);
+     if (this->isRoot(cursor_)) copy(tree_);
      else
       {
-	unsigned long pos=position(cursor_);
+	unsigned long pos=this->position(cursor_);
 	MSTabularTreeCursor<Element> cursor=cursor_;
 	cursor.setToParent();
 	MSTabularTree<Element>::removeSubtree(cursor_);
@@ -199,7 +199,7 @@ void MSObservableTree<Element>::permuteChildren(MSTabularTreeCursor<Element> con
 template <class Element>
 void MSObservableTree<Element>::elementChanged(MSTabularTreeCursor<Element> const& cursor_)
 {
-  changed(cursor_,position(cursor_),MSObservableTreeAssign);
+  changed(cursor_,this->position(cursor_),MSObservableTreeAssign);
 }
 
 template <class Element>
