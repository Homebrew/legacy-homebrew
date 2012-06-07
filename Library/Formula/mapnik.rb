require 'formula'

class Mapnik < Formula
  url 'https://github.com/downloads/mapnik/mapnik/mapnik-v2.0.1.tar.bz2'
  md5 'e3dd09991340e2568b99f46bac34b0a8'
  homepage 'http://www.mapnik.org/'
  head 'https://github.com/mapnik/mapnik.git'

  depends_on 'pkg-config' => :build
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'proj'
  depends_on 'icu4c'
  depends_on 'boost'
  depends_on 'cairomm' => :optional
  depends_on :x11

  # Reported upstream: https://github.com/mapnik/mapnik/issues/1171
  # Fix is in head.  Remove at 2.0.2.
  def patches
    DATA unless ARGV.build_head?
  end

  def install
    icu = Formula.factory("icu4c")
    # mapnik compiles can take ~1.5 GB per job for some .cpp files
    # so lets be cautious by limiting to CPUS/2
    jobs = ENV.make_jobs
    if jobs > 2
        jobs = Integer(jobs/2)
    end

    system "python",
           "scons/scons.py",
           "configure",
           "CC=\"#{ENV.cc}\"",
           "CXX=\"#{ENV.cxx}\"",
           "JOBS=#{jobs}",
           "PREFIX=#{prefix}",
           "ICU_INCLUDES=#{icu.include}",
           "ICU_LIBS=#{icu.lib}",
           "PYTHON_PREFIX=#{prefix}"  # Install to Homebrew's site-packages
    system "python",
           "scons/scons.py",
           "install"
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

__END__
--- a/bindings/python/build.py
+++ b/bindings/python/build.py
@@ -143,10 +143,7 @@ paths += "__all__ = [mapniklibpath,inputpluginspath,fontscollectionpath]\n"
 if not os.path.exists('mapnik'):
     os.mkdir('mapnik')

-if hasattr(os.path,'relpath'): # python 2.6 and above
-    file('mapnik/paths.py','w').write(paths % (os.path.relpath(env['MAPNIK_LIB_DIR'],target_path)))
-else:
-    file('mapnik/paths.py','w').write(paths % (env['MAPNIK_LIB_DIR']))
+file('mapnik/paths.py','w').write(paths % (env['MAPNIK_LIB_DIR']))

 # force open perms temporarily so that `sudo scons install`
 # does not later break simple non-install non-sudo rebuild
