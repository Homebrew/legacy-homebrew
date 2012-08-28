require 'formula'

class Falcon < Formula
  homepage 'http://www.falconpl.org/'
  url 'http://falconpl.org/project_dl/_official_rel/Falcon-0.9.6.8.tgz'
  md5 '8435f6f2fe95097ac2fbe000da97c242'

  head 'http://git.falconpl.org/falcon.git'

  option 'editline', "Use editline instead of readline"
  option 'feathers', "Include feathers (extra libraries)"

  depends_on 'cmake' => :build
  depends_on 'pcre'

  conflicts_with 'sdl',
    :because => "Falcon optionally depends on SDL and then the build breaks. Fix it!"

  def install
    args = std_cmake_args + %W{
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DFALCON_BIN_DIR=#{bin}
      -DFALCON_LIB_DIR=#{lib}
      -DFALCON_MAN_DIR=#{man1}
      -DFALCON_WITH_INTERNAL_PCRE=OFF
      -DFALCON_WITH_MANPAGES=ON}

    if build.include? 'editline'
      args << "-DFALCON_WITH_EDITLINE=ON"
    else
      args << "-DFALCON_WITH_EDITLINE=OFF"
    end

    if build.include? 'feathers'
      args << "-DFALCON_WITH_FEATHERS=feathers"
    else
      args << "-DFALCON_WITH_FEATHERS=NO"
    end

    system "cmake", *args
    system "make"
    system "make install"
  end
end
