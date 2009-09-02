require 'brewkit'

class Playdar <Formula
  @homepage='http://www.playdar.org'
  @head='git://github.com/mxcl/playdar.git'

  def deps
    LibraryDep.new 'taglib'
    LibraryDep.new 'boost'
    BinaryDep.new 'cmake'
  end

  def skip_clean? path
    # for some reason stripping breaks it
    path == bin+'playdar'
  end

  def install
    # RJ does this with all his projects :P
    inreplace 'CMakeLists.txt', 'SET(CMAKE_INSTALL_PREFIX "/usr/local")', ''

    system "cmake . #{std_cmake_parameters}"
    system "make install"
    
    prefix.install 'www'
    prefix.install 'plugins'
    (prefix+'plugins'+'.gitignore').unlink
  end
  
  def caveats
    <<-EOS
You have to execute playdar with its prefix as working directory, eg:
    $ cd #{prefix} && bin/playdar
    EOS
  end
end
