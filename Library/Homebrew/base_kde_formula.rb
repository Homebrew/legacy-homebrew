require 'formula'

class BaseKdeFormula < Formula
  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build

  def kdedir
    "/usr/local/kde"
  end
  def kdelibs_prefix
    Formula.factory('kdelibs').prefix
  end
  def qjson_prefix
    Formula.factory('qjson').prefix
  end
  def gettext_prefix
    Formula.factory('gettext').prefix
  end
  def docbook_prefix
    Formula.factory('docbook').prefix
  end
  def docbook_dtd
    "#{docbook_prefix}/docbook/xml/4.5"
  end
  def docbook_xsl
    Dir.glob("#{docbook_prefix}/docbook/xsl/*").first
  end

  def extra_cmake_args
  end
  def extra_prefix_path
  end
  def kde_default_cmake_args
    raise "std_cmake_parameters has changed... #{std_cmake_parameters}" if std_cmake_parameters != "-DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=None -Wno-dev"
    s = extra_prefix_path
    if s.nil?
      s = kdedir
    else
      s += ":#{kdedir}"
    end
    cmake_args = [
      '..',
      "-DCMAKE_INSTALL_PREFIX=#{kdedir}",
      #'-DCMAKE_BUILD_TYPE=None',
      '-Wno-dev',
      '-DKDE_DEFAULT_HOME=Library/Preferences/KDE',
      #"-DCMAKE_OSX_ARCHITECTURES='#{build_arch}'",
      #"-DCMAKE_PREFIX_PATH=#{s}:#{qjson_prefix}:#{gettext_prefix}",
      #"-DCMAKE_PREFIX_PATH=#{s}:#{gettext_prefix}",
      "-DCMAKE_PREFIX_PATH=#{gettext_prefix}",
      "-DDOCBOOKXML_CURRENTDTD_DIR=#{docbook_dtd}",
      "-DDOCBOOKXSL_DIR=#{docbook_xsl}",
      "-DBUILD_doc=FALSE",
      "-DBUNDLE_INSTALL_DIR=#{bin}"
    ]
    if extra_cmake_args.class == String
      cmake_args += extra_cmake_args.split
    elsif extra_cmake_args.class == Array
      cmake_args += extra_cmake_args
    end
    cmake_args
  end

  def build_arch
    if ARGV.build_universal?
      'i386;x86_64'
    elsif MacOS.prefer_64_bit?
      'x86_64'
    else
      'i386'
    end
  end

  def default_install
    ENV.x11
    ENV['MAKEFLAGS'] = "-j4"
    mkdir 'build'
    cd 'build'
    system "cmake", *kde_default_cmake_args
    system "make"
    system "make install"
    touch "#{prefix}/.installed"
  end
  def install
    default_install
  end

  def caveats; <<-EOS.undent
    Remember to run brew linkapps.
    EOS
  end

end
