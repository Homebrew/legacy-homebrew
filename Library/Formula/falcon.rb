require 'formula'

class Falcon <Formula
  url 'http://falconpl.org/project_dl/_official_rel/Falcon-0.9.6.6.tgz'
  homepage 'http://www.falconpl.org/'
  md5 '50ea7d97ec7599d6e75a6b8b5b8c685a'

  head 'http://git.falconpl.org/falcon.git', :branch => 'master', :using => :git

  depends_on 'cmake'
  depends_on 'pcre'

  def options
    [
      ['--manpages', "Install manpages"],
      ['--editline', "Use editline instead of readline"],
      ['--feathers', "Include feathers (extra libraries)"]
    ]
  end

  def install
    args = ["-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DFALCON_BIN_DIR=#{bin}",
            "-DFALCON_LIB_DIR=#{lib}",
            "-DFALCON_MAN_DIR=#{man1}",
            "-DFALCON_WITH_INTERNAL_PCRE=ON",
            "-DFALCON_WITH_INTERNAL_ZLIB=ON",
            "-DFALCON_WITH_INTERNAL=ON" ]

    if ARGV.include? '--manpages'
      args << "-DFALCON_WITH_MANPAGES=ON"
    else
      args << "-DFALCON_WITH_MANPAGES=OFF"
      args << "-DFALCON_MAN_DIR=#{man1}"
    end

    if ARGV.include? '--editline'
      args << "-DFALCON_WITH_EDITLINE=ON"
    else
      args << "-DFALCON_WITH_EDITLINE=OFF"
    end

    if ARGV.include? '--feathers'
      args << "-DFALCON_WITH_FEATHERS=feathers"
    else
      args << "-DFALCON_WITH_FEATHERS=NO"
    end

    system "cmake", *args
    system "make"
    system "make install"
  end
end