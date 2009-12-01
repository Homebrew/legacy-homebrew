require 'formula'

class Boost <Formula
  homepage 'http://www.boost.org'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.40.0/boost_1_40_0.tar.bz2'
  md5 'ec3875caeac8c52c7c129802a8483bd7'

  def patches
    { :p2 => DATA }
  end

  def install
    # we specify libdir too because the script is apparently broken
    system "./bootstrap.sh --prefix='#{prefix}' --libdir='#{lib}'"
    system "./bjam --layout=tagged --prefix='#{prefix}' --libdir='#{lib}' threading=multi install"
  end
end

__END__
https://svn.boost.org/trac/boost/changeset/56467
Index: /trunk/boost/test/impl/framework.ipp
===================================================================
--- /trunk/boost/test/impl/framework.ipp (revision 53665)
+++ /trunk/boost/test/impl/framework.ipp (revision 56467)
@@ -125,11 +125,12 @@
     {
         while( !m_test_units.empty() ) {
-            test_unit_store::value_type const& tu = *m_test_units.begin();
+            test_unit_store::value_type const& tu     = *m_test_units.begin();
+            test_unit*                         tu_ptr = tu.second;
 
             // the delete will erase this element from map
             if( ut_detail::test_id_2_unit_type( tu.second->p_id ) == tut_suite )
-                delete  static_cast<test_suite const*>(tu.second);
+                delete  (test_suite const*)tu_ptr;
             else
-                delete  static_cast<test_case const*>(tu.second);
+                delete  (test_case const*)tu_ptr;
         }
     }

 
