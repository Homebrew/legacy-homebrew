class Csync < Formula
  homepage "http://www.csync.org/"
  url "https://open.cryptomilk.org/attachments/download/27/csync-0.50.0.tar.xz"
  sha1 "8df896be17f7f038260159469a6968a9d563cb3c"

  head "git://git.csync.org/projects/csync.git"

  depends_on 'check' => :build
  depends_on 'cmake' => :build
  depends_on 'doxygen' => [:build, :optional]
  depends_on 'argp-standalone'
  depends_on 'iniparser'
  depends_on 'sqlite'
  depends_on 'libssh' => :optional
  depends_on 'log4c' => :optional
  depends_on 'samba' => :optional

  depends_on :macos => :lion

  def install
    mkdir "build" unless build.head?
    cd 'build' do
      system "cmake", "..", *std_cmake_args
      # We need to run make csync first to make the "core",
      # or the build system will freak out and try to link
      # modules against core functions that aren't compiled
      # yet. We also have to patch "link.txt" for all module
      # targets. This should probably be reported upstream.
      system "make csync"
      inreplace Dir['modules/CMakeFiles/*/link.txt'] do |s|
        s.gsub! '-o', "../src/libcsync.dylib ../src/std/libcstdlib.a -o"
      end
      # Now we can make and install.
      system "make all"
      system "make install"
    end
  end

  test do
    system bin/"csync", "-V"
  end
end
