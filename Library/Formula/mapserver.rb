require 'formula'

class Mapserver < Formula
  homepage 'http://mapserver.org/'
  url 'http://download.osgeo.org/mapserver/mapserver-6.2.0.tar.gz'
  sha1 '3aafa2c8367580bffcac8c53ec41b37cabaa2f82'

  option "with-fastcgi", "Build with fastcgi support"
  option "with-geos", "Build support for GEOS spatial operations"
  option "with-php", "Build PHP MapScript module"
  option "with-postgresql", "Build support for PostgreSQL as a data source"
  option "with-python", "Build Python MapScript module"

  # to find custom python
  env :userpaths

  depends_on :freetype
  depends_on :libpng
  depends_on 'giflib'
  depends_on 'gd' => %w{with-freetype}
  depends_on 'proj'
  depends_on 'gdal'

  depends_on 'geos' => :optional
  depends_on 'postgresql' if build.include? 'with-postgresql' and not MacOS.version >= :lion
  depends_on 'fcgi' if build.include? 'with-fastcgi'

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-proj",
      "--with-gdal",
      "--with-ogr",
    ]

    args << "--with-geos" if build.with? 'geos'
    args << "--with-php=/usr/bin/php-config" if build.include? 'with-php'

    if build.include? 'with-postgresql'
      if MacOS.version >= :lion # Lion ships with PostgreSQL libs
        args << "--with-postgis"
      else
        args << "--with-postgis=#{HOMEBREW_PREFIX}/bin/pg_config"
      end
    end

    args << "--with-fastcgi=#{HOMEBREW_PREFIX}" if build.include? 'with-fastcgi'

    system "./configure", *args
    system "make"

    install_args = []
    install_args << "PHP_EXT_DIR=#{prefix}" if build.include? 'with-php'
    system "make", "install", *install_args

    if build.include? 'with-python'
      cd 'mapscript/python' do
        system "python", "setup.py", "install"
      end
    end
  end

  def caveats; <<-EOS.undent
    The Mapserver CGI executable is #{bin}/mapserv

    If you built the PHP option:
      * Add the following line to php.ini:
        extension="#{prefix}/php_mapscript.so"
      * Execute "php -m"
      * You should see MapScript in the module list
    EOS
  end

  def test
    system "#{bin}/mapserver-config", "--version"
  end
end
