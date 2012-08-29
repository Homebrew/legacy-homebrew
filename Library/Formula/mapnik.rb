require 'formula'

class Mapnik < Formula
  homepage 'http://www.mapnik.org/'
  url 'https://github.com/downloads/mapnik/mapnik/mapnik-v2.1.0.tar.bz2'
  sha1 'b1c6a138e65a5e20f0f312a559e2ae7185adf5b6'

  head 'https://github.com/mapnik/mapnik.git'

  depends_on 'pkg-config' => :build
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'proj'
  depends_on 'icu4c'
  depends_on 'boost'
  depends_on 'cairomm' => :optional
  depends_on :x11

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
