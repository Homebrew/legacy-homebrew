class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage 'http://mapserver.org/'
  url 'http://download.osgeo.org/mapserver/mapserver-6.2.1.tar.gz'
  sha1 'bbe4234a4dcc179812c6598f68fe59a3dae63e44'
  revision 2

  bottle do
    cellar :any
    sha256 "9dbab28f8434c3468255fd19d1e2677624febecea1fc28f79f04c14df4a6fb5b" => :yosemite
    sha256 "0fa13f927801f0ccc89c6266257705ece9eaea09ea101e544d6a4040fee6e04b" => :mavericks
    sha256 "98198c61c8db8dc7b980e53a76542a821cca7c5a0b0facf127e03df1ae49ed01" => :mountain_lion
  end

  option "with-fastcgi", "Build with fastcgi support"
  option "with-geos", "Build support for GEOS spatial operations"
  option "with-php", "Build PHP MapScript module"
  option "with-postgresql", "Build support for PostgreSQL as a data source"

  env :userpaths

  depends_on 'freetype'
  depends_on 'libpng'
  depends_on 'swig' => :build
  depends_on 'giflib'
  depends_on 'gd'
  depends_on 'proj'
  depends_on 'gdal'
  depends_on 'geos' => :optional
  depends_on 'postgresql' => :optional unless MacOS.version >= :lion
  depends_on 'fcgi' if build.with? "fastcgi"
  depends_on 'cairo' => :optional

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-proj",
      "--with-gdal",
      "--with-ogr",
      "--with-wfs",
    ]

    args << "--with-geos" if build.with? 'geos'
    args << "--with-php=/usr/bin/php-config" if build.with? "php"
    args << "--with-cairo" if build.with? 'cairo'

    if build.with? 'postgresql'
      if MacOS.version >= :lion # Lion ships with PostgreSQL libs
        args << "--with-postgis"
      else
        args << "--with-postgis=#{HOMEBREW_PREFIX}/bin/pg_config"
      end
    end

    args << "--with-fastcgi=#{HOMEBREW_PREFIX}" if build.with? "fastcgi"

    unless MacOS::CLT.installed?
      inreplace 'configure', "_JTOPDIR=`echo \"$_ACJNI_FOLLOWED\" | sed -e 's://*:/:g' -e 's:/[^/]*$::'`",
                             "_JTOPDIR='#{MacOS.sdk_path}/System/Library/Frameworks/JavaVM.framework/Headers'"
    end

    system "./configure", *args
    system "make"

    install_args = []
    install_args << "PHP_EXT_DIR=#{prefix}" if build.with? "php"
    system "make", "install", *install_args

    cd 'mapscript/python' do
      system "python", "setup.py", "install", "--prefix=#{prefix}",
                                   "--single-version-externally-managed",
                                   "--record=installed-files.txt"
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

  test do
    system "#{bin}/mapserver-config", "--version"
  end
end
