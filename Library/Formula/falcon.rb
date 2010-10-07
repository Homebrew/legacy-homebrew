require 'formula'

class Falcon <Formula
    url 'http://falconpl.org/project_dl/_official_rel/Falcon-0.9.6.6.tgz'
    version '0.9.6.6'
    md5 '50ea7d97ec7599d6e75a6b8b5b8c685a'

    head 'http://git.falconpl.org/falcon.git', :branch => 'master', :using => :git
    homepage 'http://www.falconpl.org/'

    depends_on 'cmake'
    depends_on 'pcre'

    def options
        [
            ['--manpages', "Install manpages"],
            ['--editline', "Use Editline"],
            ['--feathers', "Include feathers (extra libraries)"]
        ]
    end

    def install
        configure_args = [
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DFALCON_BIN_DIR=#{bin}",
            "-DFALCON_LIB_DIR=#{lib}",
            "-DFALCON_MAN_DIR=#{prefix}/share/man/man1",
            "-DFALCON_WITH_INTERNAL_PCRE=ON",
            "-DFALCON_WITH_INTERNAL_ZLIB=ON",
            "-DFALCON_WITH_INTERNAL=ON"]

        configure_args << "-DFALCON_WITH_MANPAGES=ON" if ARGV.include? '--manpages'
        configure_args << "-DFALCON_MAN_DIR=#{prefix}/share/man/man1" if ARGV.include? '--manpages'
        configure_args << "-DFALCON_WITH_EDITLINE=ON" if ARGV.include? '--editline'
        configure_args << "-DFALCON_WITH_FEATHERS=feathers" if ARGV.include? '--feathers'

        system "cmake", *configure_args
        system "make"
        system "make install"
    end
end

