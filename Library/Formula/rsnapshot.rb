require "formula"

class Rsnapshot < Formula
  homepage "http://rsnapshot.org"

  stable do
    url "http://rsnapshot.org/downloads/rsnapshot-1.3.1.tar.gz"
    sha1 "a3aa3560dc389e1b00155a5869558522c4a29e05"

    # Fix pod2man error; docs in HEAD do not have this problem
    patch :DATA
  end

  head "https://github.com/DrHyde/rsnapshot.git"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
diff --git a/rsnapshot-program.pl b/rsnapshot-program.pl
index dfd7ef6..72de4af 100755
--- a/rsnapshot-program.pl
+++ b/rsnapshot-program.pl
@@ -6666,6 +6666,8 @@ additional disk space will be taken up.
 
 =back
 
+=back
+
 Remember that tabs must separate all elements, and that
 there must be a trailing slash on the end of every directory.
 
