require 'brewkit'

class Playdar <Formula
  @homepage='http://www.playdar.org'
  @head='git://github.com/mxcl/playdar.git'

  depends_on 'taglib'
  depends_on 'boost'
  depends_on 'cmake'

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
