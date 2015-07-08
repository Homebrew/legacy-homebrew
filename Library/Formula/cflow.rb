class Cflow < Formula
  desc "Generate call graphs from C code"
  homepage "https://www.gnu.org/software/cflow/"
  url "http://ftpmirror.gnu.org/cflow/cflow-1.4.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/cflow/cflow-1.4.tar.bz2"
  sha256 "037e39d6048ea91c68a5f3a561e10f22fd085d1f7641643e19c831a94ec26bca"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end

  test do
    (testpath/"whoami.c").write <<-EOS.undent
     #include <pwd.h>
     #include <sys/types.h>
     #include <stdio.h>
     #include <stdlib.h>

     int
     who_am_i (void)
     {
       struct passwd *pw;
       char *user = NULL;

       pw = getpwuid (geteuid ());
       if (pw)
         user = pw->pw_name;
       else if ((user = getenv ("USER")) == NULL)
         {
           fprintf (stderr, "I don't know!\n");
           return 1;
         }
       printf ("%s\n", user);
       return 0;
     }

     int
     main (int argc, char **argv)
     {
       if (argc > 1)
         {
           fprintf (stderr, "usage: whoami\n");
           return 1;
         }
       return who_am_i ();
     }
    EOS

    assert_match /getpwuid()/, shell_output("#{bin}/cflow --main who_am_i #{testpath}/whoami.c")
  end
end
