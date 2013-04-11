require 'formula'

class Sdcc < Formula
  homepage 'http://sdcc.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/sdcc/sdcc/3.1.0/sdcc-src-3.1.0.tar.bz2'
  sha1 '4806c79bd1572c3be8e8a9ee68f94c31d251d530'

  head 'https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc/'

  depends_on 'gputils'
  depends_on 'boost'

  option 'enable-avr-port', "Enables the AVR port (UNSUPPORTED, MAY FAIL)"
  option 'enable-xa51-port', "Enables the xa51 port (UNSUPPORTED, MAY FAIL)"

  def patches
    p = []

    # SDCC Doesn't build huge-stack-auto by default for mcs51, but it
    # is needed by Contiki and others. This simple patch enables it to build.
    p << 'https://gist.github.com/anonymous/5042275/raw/a2e084f29cd4ad9cd95e38683209991b7ac038d3/sdcc-huge-stack-auto.diff'

    # The issue the patch below fixes is already fixed on HEAD, so
    # we only want to apply it if we aren't building for HEAD.
    p << DATA if !build.head?
    p
  end

  def install
    args = ["--prefix=#{prefix}"]

    args << '--enable-avr-port' if build.include? 'enable-avr-port'
    args << '--enable-xa51-port' if build.include? 'enable-xa51-port'

    system "./configure", *args
    system "make all"
    system "make install"
  end

  def test
    system "#{bin}/sdcc", "-v"
  end
end

__END__
diff --git a/src/SDCCralloc.hpp b/src/SDCCralloc.hpp
index 25f01f0..2b02130 100644
--- a/src/SDCCralloc.hpp
+++ b/src/SDCCralloc.hpp
@@ -413,7 +413,7 @@ create_cfg(cfg_t &cfg, con_t &con, ebbIndex *ebbi)
   for (var_t i = boost::num_vertices(con) - 1; i >= 0; i--)
     {
       cfg_sym_t cfg2;
-      boost::copy_graph(cfg, cfg2);
+      boost::copy_graph(cfg, cfg2, boost::vertex_copy(forget_properties()).edge_copy(forget_properties()));
       for (int j = boost::num_vertices(cfg) - 1; j >= 0; j--)
         {
           if (cfg[j].alive.find(i) == cfg[j].alive.end())
@@ -430,7 +430,7 @@ create_cfg(cfg_t &cfg, con_t &con, ebbIndex *ebbi)
 #endif
           // Non-connected CFGs shouldn't exist either. Another problem with dead code eliminarion.
           cfg_sym_t cfg2;
-          boost::copy_graph(cfg, cfg2);
+          boost::copy_graph(cfg, cfg2, boost::vertex_copy(forget_properties()).edge_copy(forget_properties()));
           std::vector<boost::graph_traits<cfg_t>::vertices_size_type> component(num_vertices(cfg2));
           boost::connected_components(cfg2, &component[0]);

diff --git a/src/SDCCtree_dec.hpp b/src/SDCCtree_dec.hpp
index e5b1de3..3ec8898 100644
--- a/src/SDCCtree_dec.hpp
+++ b/src/SDCCtree_dec.hpp
@@ -53,6 +53,14 @@
 #include <boost/graph/copy.hpp>
 #include <boost/graph/adjacency_list.hpp>

+struct forget_properties
+{
+  template<class T1, class T2>
+  void operator()(const T1&, const T2&) const
+  {
+  }
+};
+
 // Thorup algorithm D.
 // The use of the multimap makes the complexity of this O(|I|log|I|), which could be reduced to O(|I|).
 template <class l_t>
@@ -152,7 +160,7 @@ void thorup_elimination_ordering(l_t &l, const G_t &G)
 {
   // Should we do this? Or just use G as J? The Thorup paper seems unclear, it speaks of statements that contain jumps to other statements, but does it count as a jump, when they're just subsequent?
   boost::adjacency_list<boost::vecS, boost::vecS, boost::directedS> J;
-  boost::copy_graph(G, J);
+  boost::copy_graph(G, J, boost::vertex_copy(forget_properties()).edge_copy(forget_properties()));
   for (unsigned int i = 0; i < boost::num_vertices(J) - 1; i++)
     remove_edge(i, i + 1, J);

@@ -256,7 +264,7 @@ void tree_decomposition_from_elimination_ordering(T_t &T, const std::list<unsign

   // Todo: Implement a graph adaptor for boost that allows to treat directed graphs as undirected graphs.
   boost::adjacency_list<boost::vecS, boost::vecS, boost::undirectedS> G_sym;
-  boost::copy_graph(G, G_sym);
+  boost::copy_graph(G, G_sym, boost::vertex_copy(forget_properties()).edge_copy(forget_properties()));

   std::vector<bool> active(boost::num_vertices(G), true);
