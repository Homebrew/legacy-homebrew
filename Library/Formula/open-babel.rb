require 'formula'

class OasaPythonModule < Requirement
  def message; <<-EOS.undent
    The oasa Python module is required for some operations.
    It can be downloaded from:
      http://bkchem.zirael.org/oasa_en.html
    Or with the command:
      pip install -f http://bkchem.zirael.org/ oasa==0.13.1
    (may first require 'brew install py2cairo')
    EOS
  end
  def satisfied?
    args = %W{/usr/bin/env python -c import\ oasa}
    quiet_system *args
  end
end

def which_python
  "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end

def site_package_dir
  "#{lib}/#{which_python}/site-packages"
end

class OpenBabel < Formula
  homepage 'http://openbabel.org/'
  url 'http://sourceforge.net/projects/openbabel/files/openbabel/2.3.1/openbabel-2.3.1.tar.gz'
  md5 '1f029b0add12a3b55582dc2c832b04f8'
  head 'https://openbabel.svn.sourceforge.net/svnroot/openbabel/openbabel/trunk'

  depends_on OasaPythonModule.new

  if ARGV.build_head?
    depends_on 'eigen' # eigen3
    depends_on 'swig' => :build
  else
    depends_on 'eigen2'
  end
  depends_on 'cmake' => :build

  
  def install
    ENV.deparallelize
    args = std_cmake_parameters.split
    if ARGV.build_head?
      args << "-DEIGEN3_INCLUDE_DIR='#{HOMEBREW_PREFIX}/include/eigen3'"
    else
      args << "-DEIGEN2_INCLUDE_DIR='#{HOMEBREW_PREFIX}/include/eigen2'"
    end
    args << '-DPYTHON_BINDINGS=ON'
    args << '-DRUN_SWIG=TRUE' if ARGV.build_head?

    # This block is copied from opencv.rb formula:
    #
    #  The CMake `FindPythonLibs` Module is dumber than a bag of hammers when
    #  more than one python installation is available---for example, it clings
    #  to the Header folder of the system Python Framework like a drowning
    #  sailor.
    #
    #  This code was cribbed from the VTK formula and uses the output to
    #  `python-config` to do the job FindPythonLibs should be doing in the first
    #  place.
    python_prefix = `python-config --prefix`.strip
    # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
    if File.exist? "#{python_prefix}/Python"
      # Python was compiled with --framework:
      args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
      args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
    else
      python_lib = "#{python_prefix}/lib/lib#{which_python}"
      if File.exists? "#{python_lib}.a"
        args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
      else
        args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
      end
      args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/#{which_python}'"
    end

    args << '.'

    # The cmake script for 2.3.1 tries to guess where the compiled module ought 
    # to live, and often gets it wrong. We know where we put it, so tell it:
    inreplace 'scripts/CMakeLists.txt', '${PYTHON_LIB_PATH}/_openbabel.so', "#{site_package_dir}/_openbabel.so" unless ARGV.build_head?

    system "cmake", *args
    system "make"
    system "make install"

    if ARGV.build_head?
      # The simplified build system on the HEAD doesn't put the python stuff in 
      # the right place so we have to move it into #{site_package_dir}
      mkdir_p site_package_dir
      mv ["#{lib}/_openbabel.so", "#{lib}/openbabel.py", "#{lib}/pybel.py"], site_package_dir
    end
    # remove the spurious cmake folders from lib
    rmtree "#{lib}/cmake"

  end

  def caveats; <<-EOS.undent
    The Python bindings were installed to #{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages
    so you may need to update your PYTHONPATH like so:
      export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH"
    To make this permanent, put it in your shell's profile (e.g. ~/.profile).

    To draw images from python, you will need to get the oasa Python module:
      pip install -f http://bkchem.zirael.org/ oasa==0.13.1
    EOS
  end
end
