require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Edje < Formula
  homepage 'http://docs.enlightenment.org/auto/edje/'
  url 'http://download.enlightenment.org/releases/edje-1.7.5.tar.bz2'
  sha1 'ce2fff866e7e421b952ed0d2f31566e0305d2f11'

  head 'http://svn.enlightenment.org/svn/e/trunk/edje/'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'eina'
  depends_on 'eet'
  depends_on 'evas'
  depends_on 'embryo'
  depends_on 'lua'

  depends_on 'pkg-config' => :build

  def patches
    # makes embryo_cc inside edje_cc work if their bin_prefixes differ
    DATA
  end

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test edje`.
    system "false"
  end
end

__END__
diff --git a/src/bin/edje_cc_out.c b/src/bin/edje_cc_out.c
index bf2ddcd..280921b 100644
--- a/src/bin/edje_cc_out.c
+++ b/src/bin/edje_cc_out.c
@@ -1291,8 +1291,7 @@ data_write_scripts(Eet_File *ef)
           }
         create_script_file(ef, sc->tmpn, cd, sc->tmpn_fd);
         snprintf(buf, sizeof(buf),
-                 "%s/embryo_cc -i %s/include -o %s %s",
-                 eina_prefix_bin_get(pfx),
+                 "embryo_cc -i %s/include -o %s %s",
                  eina_prefix_data_get(pfx),
                  sc->tmpo, sc->tmpn);
         pending_threads++;
