require 'formula'

class Mapserver < Formula
  homepage 'http://mapserver.org/'
  url 'http://download.osgeo.org/mapserver/mapserver-6.4.0.tar.gz'
  sha1 '8af4883610091de7ba374ced2564ed90ca2faa5b'

  head do
    url 'https://github.com/mapserver/mapserver.git', :branch => 'master'
    depends_on 'harfbuzz'
    depends_on 'v8' => :optional
  end

  option 'with-php', 'Build PHP MapScript module'
  option 'with-ruby', 'Build Ruby MapScript module'
  option 'with-perl', 'Build Perl MapScript module'
  option 'with-java', 'Build Java MapScript module'
  option 'with-sos', 'Build with SOS server support'
  option 'with-gd', 'Build with GD support (deprecated)' unless build.head?
  option 'with-librsvg', 'Build with SVG symbology support'
  option 'without-geos', 'Build without GEOS spatial operations support'
  option 'without-postgresql', 'Build without PostgreSQL data source support'
  option 'without-ows-clients', 'Build without WMS and WFS client support'
  option 'with-docs', 'Download and generate HTML documentation'

  depends_on 'cmake' => :build
  depends_on :freetype
  depends_on :fontconfig
  depends_on :libpng
  depends_on :python => :recommended
  depends_on 'swig' => :build
  depends_on 'giflib'
  depends_on 'gd' => [:optional, 'with-freetype'] unless build.head?
  depends_on 'proj'
  depends_on 'geos' => :recommended
  depends_on 'gdal'
  depends_on :postgresql => :recommended
  depends_on :mysql => :optional
  depends_on 'fcgi' => :recommended
  depends_on 'cairo' => :recommended
  depends_on 'libxml2' unless MacOS.version >= :mountain_lion
  depends_on 'librsvg' => :optional
  depends_on 'fribidi'
  depends_on :python => %w[sphinx] if build.with? 'docs'

  resource 'docs' do
    # NOTE: seems to be no tagged releases for `docs`, just active branches
    url 'https://github.com/mapserver/docs.git', :branch => 'branch-6-4'
    version '6.4'
  end

  # fix ruby module's output suffix
  # see: https://github.com/mapserver/mapserver/pull/4826
  def patches
    DATA
  end

  def install
    cxxstdlib_check :skip

    args = std_cmake_args
    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch_64_bit}"
    else
      args << '-DCMAKE_OSX_ARCHITECTURES=i386'
    end

    # defaults different than CMakeLists.txt
    args.concat %W[
      -DWITH_KML=ON
    ]

    ft = Formula.factory('freetype')
    if ft.installed?
      args.concat %W[
        -DFREETYPE_INCLUDE_DIR_ft2build=#{ft.opt_prefix}/include/freetype
        -DFREETYPE_INCLUDE_DIR_freetype2=#{ft.opt_prefix}/include/freetype
        -DFREETYPE_LIBRARY=#{ft.opt_prefix}/lib/libfreetype.dylib
      ]
    end

    fc = Formula.factory('fontconfig')
    args << "-DFC_INCLUDE_DIR=#{fc.opt_prefix}/include" if fc.installed?

    args << '-DWITH_SOS=ON' if build.with? 'sos'
    unless build.without? 'ows-clients'
      args.concat %w[
        -DWITH_CURL=ON
        -DWITH_CLIENT_WMS=ON
        -DWITH_CLIENT_WFS=ON
      ]
    end

    pg = Formula.factory('postgresql')
    if build.with? 'postgresql' && pg.installed?
      args.concat %W[
        -DPOSTGRESQL_INCLUDE_DIR=#{pg.opt_prefix}/include
        -DPOSTGRESQL_LIBRARY=#{pg.opt_prefix}/lib/libpq.dylib
      ]
    end

    if build.with? 'mysql'
      args << '-DWITH_MYSQL=ON'
      my = Formula.factory('mysql')
      if my.installed?
        args.concat %W[
          -DMYSQL_INCLUDE_DIR=#{my.opt_prefix}/include
          -DMYSQL_LIBRARY=#{my.opt_prefix}/lib/libmysqlclient.dylib
        ]
      end
    end

    args << '-DWITH_GD=ON' if build.with? 'gd' && !build.head?
    args << '-DWITH_RSVG=ON' if build.with? 'librsvg'

    mapscr_dir = prefix/'mapscript'
    mapscr_dir.mkpath
    cd 'mapscript' do
      args << '-DWITH_PYTHON=ON'
      inreplace 'python/CMakeLists.txt', '${PYTHON_SITE_PACKAGES}', "\"#{lib/python.xy/'site-packages'}\""

      # override language extension install locations, e.g. install to prefix/'mapscript/lang'
      if build.with? 'ruby'
        args << '-DWITH_RUBY=ON'
        (mapscr_dir/'ruby').mkpath
        site_arch = (build.head?) ? '${RUBY_SITEARCHDIR}' : '${RUBY_ARCHDIR}'
        inreplace 'ruby/CMakeLists.txt', site_arch, "\"#{mapscr_dir}/ruby\""
      end

      if build.with? 'php'
        args << '-DWITH_PHP=ON'
        (mapscr_dir/'php').mkpath
        inreplace 'php/CMakeLists.txt', '${PHP5_EXTENSION_DIR}', "\"#{mapscr_dir}/php\""
      end

      if build.with? 'perl'
        args << '-DWITH_PERL=ON'
        (mapscr_dir/'perl').mkpath
        args << "-DCUSTOM_PERL_SITE_ARCH_DIR=#{mapscr_dir}/perl"
      end

      if build.with? 'java'
        args << '-DWITH_JAVA=ON'
        ENV['JAVA_HOME'] = `/usr/libexec/java_home`.chomp!
        (mapscr_dir/'java').mkpath
        lib_dir = (build.head?) ? '${CMAKE_INSTALL_LIBDIR}' : 'lib'
        inreplace 'java/CMakeLists.txt', "DESTINATION #{lib_dir}", "DESTINATION \"#{mapscr_dir}/java\""
      end
    end

    mkdir 'build' do
      python do
        system 'cmake', '..', *args
        #system 'bbedit', 'CMakeCache.txt'
        #raise
        system 'make install'
      end
    end

    # fix @rpath in modules, so non-standard HOMEBREW_PREFIX works
    # TODO: how to keep swig from doing this? (tried a bunch of CMake RPATH settings)
    def fix_rpath(mod_dir, shared_lib)
      cd mod_dir do
        sys_args = %W[
          -change
          @rpath/libmapserver.1.dylib
          #{opt_prefix}/lib/libmapserver.1.dylib
          #{shared_lib}
        ]
        Homebrew.system('install_name_tool', *sys_args) do
          $stdout.reopen('/dev/null')
        end
      end
    end
    fix_rpath(lib/python.xy/'site-packages', '_mapscript.so')
    fix_rpath(mapscr_dir/'php', 'php_mapscript.so') if build.with? 'php'
    fix_rpath(mapscr_dir/'ruby', 'mapscript.bundle') if build.with? 'ruby'
    fix_rpath(mapscr_dir/'perl/auto/mapscript', 'mapscript.bundle') if build.with? 'perl'
    fix_rpath(mapscr_dir/'java', 'libjavamapscript.jnilib') if build.with? 'java'

    # install devel headers
    # TODO: not quite sure which of these headers are unnecessary to copy
    (include/'mapserver').install Dir['*.h']

    if build.with? 'docs'
      resource('docs').stage do
        inreplace 'Makefile', 'sphinx-build', "#{HOMEBREW_PREFIX}/bin/sphinx-build"
        system 'make', 'html'
        doc.install 'build/html' => 'html'
      end
    end
  end

  def caveats
    mapscr_dir = opt_prefix/'mapscript'
    s = <<-EOS.undent
      The Mapserver CGI executable is #{opt_prefix}/bin/mapserv

    EOS
    if build.with? 'php'
      s += <<-EOS.undent
        Using the built PHP module:
          * Add the following line to php.ini:
            extension="#{mapscr_dir}/php/php_mapscript.so"
          * Execute "php -m"
          * You should see MapScript in the module list

      EOS
    end
    %w[ruby perl java].each do |m|
      if build.with? m
        cmd = []
        case m
          when 'ruby'
            ruby_site = %x[ruby -r rbconfig -e 'puts RbConfig::CONFIG["sitearchdir"]'].chomp
            cmd << "sudo cp -f mapscript.bundle #{ruby_site}/"
          when 'perl'
            perl_site = %x[perl -MConfig -e 'print $Config{"sitearch"};'].chomp
            cmd << "sudo cp -f mapscript.pm #{perl_site}/"
            cmd << "sudo cp -fR auto/mapscript #{perl_site}/auto/"
          when 'java'
            cmd << 'sudo cp -f libjavamapscript.jnilib /Library/Java/Extensions/'
        end
        s += <<-EOS.undent
          Install the built #{m.upcase} module with:
            cd #{mapscr_dir}/#{m}
            #{cmd[0]}
            #{cmd[1] + "\n" if cmd[1]}
        EOS
      end
    end
    s
  end

  def test
    system "#{bin}/mapserv", '-v'
    system 'python', '-c', '"import mapscript"'
    system 'ruby', '-e', "\"require '#{opt_prefix}/mapscript/ruby/mapscript'\"" if build.with? 'ruby'
    system 'perl', "-I#{opt_prefix}/mapscript/perl", '-e', '"use mapscript;"' if build.with? 'perl'
  end
end

__END__
diff --git a/mapscript/ruby/CMakeLists.txt b/mapscript/ruby/CMakeLists.txt
index 95f5982..2dc084a 100644
--- a/mapscript/ruby/CMakeLists.txt
+++ b/mapscript/ruby/CMakeLists.txt
@@ -11,6 +11,9 @@ SWIG_LINK_LIBRARIES(rubymapscript ${RUBY_LIBRARY} ${MAPSERVER_LIBMAPSERVER})

 set_target_properties(${SWIG_MODULE_rubymapscript_REAL_NAME} PROPERTIES PREFIX "")
 set_target_properties(${SWIG_MODULE_rubymapscript_REAL_NAME} PROPERTIES OUTPUT_NAME mapscript)
+if(APPLE)
+  set_target_properties(${SWIG_MODULE_rubymapscript_REAL_NAME} PROPERTIES SUFFIX ".bundle")
+endif(APPLE)

 get_target_property(LOC_MAPSCRIPT_LIB ${SWIG_MODULE_rubymapscript_REAL_NAME} LOCATION)
 execute_process(COMMAND ${RUBY_EXECUTABLE} -r rbconfig -e "puts RbConfig::CONFIG['archdir']" OUTPUT_VARIABLE RUBY_ARCHDIR OUTPUT_STRIP_TRAILING_WHITESPACE)
