require 'formula'

class Libplist < Formula
  url 'http://cgit.sukimashita.com/libplist.git/snapshot/libplist-1.4.tar.bz2'
  homepage 'http://cgit.sukimashita.com/libplist.git/'
  md5 '53c278ea6aa0617f45fad263c688b2a4'

  depends_on 'cmake' => :build
  depends_on 'glib'
  depends_on 'libxml2'

  def install
    # Disable Python bindings.
    inreplace "CMakeLists.txt", 'OPTION(ENABLE_PYTHON "Enable Python bindings (needs Swig)" ON)',
                                '# Disabled Python Bindings'
    system "cmake . #{std_cmake_parameters} -DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "make install"

    # Remove 'plutil', which duplicates the system-provided one. Leave the versioned one, though.
    rm (bin+'plutil')
  end
end
