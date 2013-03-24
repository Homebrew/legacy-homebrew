require 'formula'

class Libplist < Formula
  homepage 'http://cgit.sukimashita.com/libplist.git/'
  url 'http://cgit.sukimashita.com/libplist.git/snapshot/libplist-1.8.tar.bz2'
  sha1 'dea18ac31cc497dba959bdb459a2a49fb41664c3'
  head 'http://git.sukimashita.com/libplist.git'

  # Needed to find the Cython executable
  env :userpaths

  depends_on 'cmake' => :build

  if build.include? 'python'
    depends_on 'Cython' => :python
  end

  option 'python', 'Enable Cython Python bindings'

  # Fix 3 Clang compile errors.  Similar fixes are upstream. Reverify in 1.9
  def patches
    # Only apply patches if we don't build with '--HEAD'
    if !build.head?
      DATA
    end
  end

  def install
    ENV.deparallelize # make fails on an 8-core Mac Pro

    args = std_cmake_args

    # Disable Swig Python bindings
    args << "-DENABLE_SWIG='OFF'"

    # Also disable Cython Python bindings if we're not building with '--python'
    if !build.include? 'python'
      args << "-DENABLE_CYTHON='OFF'"
    end

    if build.include? 'python'
      ## Taken from opencv.rb
      #
      # The CMake `FindPythonLibs` Module is dumber than a bag of hammers when
      # more than one python installation is available---for example, it clings
      # to the Header folder of the system Python Framework like a drowning
      # sailor.
      #
      # This code was cribbed from the VTK formula and uses the output to
      # `python-config` to do the job FindPythonLibs should be doing in the first
      # place.
      python_prefix = `python-config --prefix`.strip
      # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
      if File.exist? "#{python_prefix}/Python"
      # Python was compiled with --framework:
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        if !MacOS::CLT.installed? and python_prefix.start_with? '/System/Library'
          # For Xcode-only systems, the headers of system's python are inside of Xcode
          args << "-DPYTHON_INCLUDE_DIR='#{MacOS.sdk_path}/System/Library/Frameworks/Python.framework/Versions/2.7/Headers'"
        else
          args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
        end
      else
        python_lib = "#{python_prefix}/lib/lib#{which_python}"
        if File.exists? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/#{which_python}'"
      end
      args << "-DPYTHON_PACKAGES_PATH='#{lib}/#{which_python}/site-packages'"
    end

    system "cmake", ".", "-DCMAKE_INSTALL_NAME_DIR=#{lib}", *args
    system "make install"

    # Remove 'plutil', which duplicates the system-provided one. Leave the versioned one, though.
    rm (bin+'plutil')
  end

  def caveats
    if build.include? 'python'
      <<-EOS.undent
        To use the Python bindings with non-homebrew Python, you need to amend your
        PYTHONPATH like so:
          export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
      EOS
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

__END__
--- a/libcnary/node.c 2011-06-24 18:00:48.000000000 -0700
+++ b/libcnary/node.c 2012-01-26 13:59:51.000000000 -0800
@@ -104,7 +104,7 @@
 
 int node_insert(node_t* parent, unsigned int index, node_t* child)
 {
- if (!parent || !child) return;
+ if (!parent || !child) return 0;
  child->isLeaf = TRUE;
  child->isRoot = FALSE;
  child->parent = parent;
--- a/src/base64.c  2011-06-24 18:00:48.000000000 -0700
+++ b/src/base64.c  2012-01-26 14:01:21.000000000 -0800
@@ -104,9 +104,9 @@
 
 unsigned char *base64decode(const char *buf, size_t *size)
 {
- if (!buf) return;
+ if (!buf) return NULL;
  size_t len = strlen(buf);
- if (len <= 0) return;
+ if (len <= 0) return NULL;
  unsigned char *outbuf = (unsigned char*)malloc((len/4)*3+3);
 
  unsigned char *line;
