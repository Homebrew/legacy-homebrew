require 'formula'

class Icu4c <Formula
  url 'http://download.icu-project.org/files/icu4c/4.4.1/icu4c-4_4_1-src.tgz'
  homepage 'http://site.icu-project.org/'
  md5 'b6bc0a1153540b2088f8b03e0ba625d3'
  version "4.4.1"

  def patches
    DATA
  end

  keg_only "Conflicts; see: http://github.com/mxcl/homebrew/issues/issue/167"

  def install
    ENV.append "LDFLAGS", "-headerpad_max_install_names"
    config_flags = ["--prefix=#{prefix}", "--disable-samples", "--enable-static"]
    config_flags << "--with-library-bits=64" if snow_leopard_64?
    Dir.chdir "source" do
      system "./configure", *config_flags
      system "make"
      system "make install"
    end

    # fix install_names
    lib.children.reject{ |pn| pn.symlink? or pn.extname != '.dylib' }.each do |dylib|
      bad_names(dylib) do |id, bad_names|
        cd lib do
          system "install_name_tool", "-id", (lib+id).realpath, dylib.basename
          bad_names.each do |bad|
            system "install_name_tool", "-change", bad, (lib+bad.basename).realpath, dylib.basename
          end
        end
      end
    end
  end

  def bad_names pn
    ENV['HOMEBREW_PN'] = pn.to_s
    rx = /\t(.*) \(compatibility version (\d+\.)*\d+, current version (\d+\.)*\d+\)/
    dylibs = `otool -L "$HOMEBREW_PN"`.split "\n"
    dylibs = dylibs.map{ |fn| rx =~ fn && $1 }.compact.reject{ |fn| fn[0].chr == '/' }.map{ |fn| Pathname.new fn }
    yield dylibs.shift, dylibs
  end
end


__END__
--- a/source/configure	2009-07-02 03:51:26.000000000 +0900
+++ b/source/configure	2009-08-16 16:15:49.000000000 +0900
@@ -7058,11 +7058,8 @@
 	 test ! -s conftest.err
        } && test -s conftest.$ac_objext; then

-	# Check for potential -arch flags.  It is not universal unless
-	# there are some -arch flags.  Note that *ppc* also matches
-	# ppc64.  This check is also rather less than ideal.
 	case "${CC} ${CFLAGS} ${CPPFLAGS} ${LDFLAGS}" in  #(
-	  *-arch*ppc*|*-arch*i386*|*-arch*x86_64*) ac_cv_c_bigendian=universal;;
+	  *-arch*ppc*) ac_cv_c_bigendian=yes;;
 	esac
 else
   $as_echo "$as_me: failed program was:" >&5
