require 'formula'

class Bbcp < Formula
  homepage 'http://www.slac.stanford.edu/%7Eabh/bbcp'
  url 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.tgz'
  version '13.05.03.00.0'
  sha1 '218911904b46f7aff3784705581737f53eccbc53'
  head 'http://www.slac.stanford.edu/~abh/bbcp/bbcp.git'

  # Adds missing required return type specification on 'main'
  def patches; DATA; end

  def install
    mkdir "bin"
    mkdir "obj"

    cd "src" do
      system "make", "Darwin"
    end

    bin.install "bin/bbcp"
  end

  def test
    system "#{bin}/bbcp", "--help"
  end
end

__END__
diff --git c/src/bbcp.C w/src/bbcp.C
index 03c6d4e..7116fff 100644
--- c/src/bbcp.C
+++ w/src/bbcp.C
@@ -58,7 +58,7 @@ extern bbcp_System   bbcp_OS;
 /*                                  m a i n                                   */
 /******************************************************************************/
   
-main(int argc, char *argv[], char *envp[])
+int main(int argc, char *argv[], char *envp[])
 {
    bbcp_Node     *Source, *Sink;
    bbcp_Protocol  Protocol;
