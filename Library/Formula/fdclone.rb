require 'formula'

class Fdclone < Formula
  homepage 'http://hp.vector.co.jp/authors/VA012337/soft/fd/'
  url 'http://hp.vector.co.jp/authors/VA012337/soft/fd/FD-3.01a.tar.gz'
  sha1 '5d4f90ccaee67fadcc5d776f90bbe2fd760c4cdd'

  depends_on 'nkf' => :build

  def patches
    DATA
  end

  def install
    ENV.j1
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "MANTOP=#{man}", "install"

    %w(README FAQ HISTORY LICENSES TECHKNOW ToAdmin).each do |file|
      system "nkf", "-w", "--overwrite", file
      prefix.install "#{file}.eng" => file
      prefix.install file => "#{file}.ja"
    end

    share.install "_fdrc" => "fd2rc.dist"
  end

  def caveats; <<-EOS.undent
    To install the initial config file:
        install -c -m 0644 #{share}/fd2rc.dist ~/.fd2rc
    EOS
  end
end

__END__
diff --git a/machine.h b/machine.h
index 8bc70ab..39b0d28 100644
--- a/machine.h
+++ b/machine.h
@@ -1449,4 +1449,6 @@ typedef unsigned long		u_long;
 #define	GETTODARGS		2
 #endif

+#define USEDATADIR
+
 #endif	/* !__MACHINE_H_ */
