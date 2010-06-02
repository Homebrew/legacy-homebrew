require 'formula'

class Libplist <Formula
  url 'http://cloud.github.com/downloads/JonathanBeck/libplist/libplist-1.3.tar.bz2'
  homepage 'http://github.com/JonathanBeck/libplist'
  md5 '0f48f4da8ddba5d7e186307622bf2c62'

  depends_on 'cmake'
  depends_on 'glib'
  depends_on 'libxml2'

  def keg_only?
    "This brew provides libmagic, but also installs a 'file' command which shadows the OS X-provided command."
  end

  def install
    # Disable Python bindings.
    inreplace "CMakeLists.txt", 'OPTION(ENABLE_PYTHON "Enable Python bindings (needs Swig)" ON)', '# Disabled Python Bindings'
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
