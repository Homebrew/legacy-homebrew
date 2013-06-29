require 'formula'

class Wrangler < Formula
  homepage 'http://www.cs.kent.ac.uk/projects/forse/'
  url 'http://www.cs.kent.ac.uk/projects/forse/wrangler/wrangler-0.9/wrangler-0.9.3.1.tar.gz'
  sha1 'a0afccf0ad08c070e275d48b4cbd179b4368bba4'

  depends_on 'erlang'

  def patches
    # Respect $CC during compilation. Merged upstream:
    # https://github.com/RefactoringTools/wrangler/pull/41
    DATA
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff --git i/c_src/gsuffixtree/Makefile.in w/c_src/gsuffixtree/Makefile.in
index 3f4e6fa..751ed55 100755
--- i/c_src/gsuffixtree/Makefile.in
+++ w/c_src/gsuffixtree/Makefile.in
@@ -1,5 +1,6 @@
  
 
+CC          = @CC@
 ERL_CFLAGS  = @ERL_CFLAGS@
 ERL_LIB     = @ERL_LIB@
 CFLAGS      = @CFLAGS@
@@ -10,13 +11,13 @@ ERL_LDFLAGS= ${LDFLAGS} ${ERL_LIB}
 
 
 gsuffixtree:	main.o gsuffix_tree.o
-	gcc  ${ERL_LDFLAGS} main.o gsuffix_tree.o -lerl_interface -lei -lpthread -o gsuffixtree 
+	$(CC) ${ERL_LDFLAGS} main.o gsuffix_tree.o -lerl_interface -lei -lpthread -o gsuffixtree
 
 gsuffix_tree.o:	gsuffix_tree.c gsuffix_tree.h
-	gcc ${CFLAGS} ${ERL_CFLAGS} -o gsuffix_tree.o -c gsuffix_tree.c
+	$(CC) ${CFLAGS} ${ERL_CFLAGS} -o gsuffix_tree.o -c gsuffix_tree.c
 
 main.o:	gsuffix_tree.h 
-	gcc ${CFLAGS} ${ERL_CFLAGS} -o main.o -c main.c 
+	$(CC) ${CFLAGS} ${ERL_CFLAGS} -o main.o -c main.c
 
 clean: 
 	-rm -f *.o 
diff --git i/c_src/suffixtree/Makefile.in w/c_src/suffixtree/Makefile.in
index 8ed7c1d..3f40de4 100755
--- i/c_src/suffixtree/Makefile.in
+++ w/c_src/suffixtree/Makefile.in
@@ -1,5 +1,6 @@
  
 
+CC          = @CC@
 ERL_CFLAGS  = @ERL_CFLAGS@
 ERL_LIB     = @ERL_LIB@
 CFLAGS      = @CFLAGS@
@@ -10,13 +11,13 @@ ERL_LDFLAGS= ${LDFLAGS} ${ERL_LIB}
 
 
 suffixtree:	main.o suffix_tree.o
-	gcc  ${ERL_LDFLAGS} main.o suffix_tree.o -lerl_interface -lei -lpthread -o suffixtree 
+	$(CC) ${ERL_LDFLAGS} main.o suffix_tree.o -lerl_interface -lei -lpthread -o suffixtree
 
 suffix_tree.o:	suffix_tree.c suffix_tree.h
-	gcc ${CFLAGS} ${ERL_CFLAGS} -o suffix_tree.o -c suffix_tree.c
+	$(CC) ${CFLAGS} ${ERL_CFLAGS} -o suffix_tree.o -c suffix_tree.c
 
 main.o:	suffix_tree.h 
-	gcc ${CFLAGS} ${ERL_CFLAGS} -o main.o -c main.c 
+	$(CC) ${CFLAGS} ${ERL_CFLAGS} -o main.o -c main.c
 
 clean: 
 	-rm -f *.o 
