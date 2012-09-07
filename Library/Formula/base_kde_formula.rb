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
    ""
  end
  def kde_default_cmake_args
    "-DCMAKE_INSTALL_PREFIX=#{kdedir} -DCMAKE_PREFIX_PATH=#{qjson_prefix}:#{gettext_prefix} -DDOCBOOKXML_CURRENTDTD_DIR=#{docbook_dtd} -DDOCBOOKXSL_DIR=#{docbook_xsl} -DBUILD_doc=FALSE"
  end
  def default_install
    ENV.x11
    mkdir 'build'
    cd 'build'
    # this has to be installed along with this kdelibs. // kde4-config --prefix
    system "cmake .. #{std_cmake_parameters} #{kde_default_cmake_args} #{extra_cmake_args} -DBUNDLE_INSTALL_DIR=#{bin}"
    #system "touch #{prefix}/something"
    system "make install"
  end
  def install
    default_install
  end

  def caveats; <<-EOS.undent
    Remember to run brew linkapps.
    EOS
  end

end
