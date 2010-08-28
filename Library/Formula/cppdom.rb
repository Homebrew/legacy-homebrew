require 'formula'

class Cppdom <Formula
  url 'http://downloads.sourceforge.net/project/xml-cppdom/CppDOM/1.0.1/cppdom-1.0.1.tar.gz'
  homepage 'http://sourceforge.net/projects/xml-cppdom/'
  md5 'ab30e45eb8129e14040020edc5b0b130'

  depends_on 'scons'
  depends_on 'boost'

  def install
    args = ["prefix=#{prefix}", "build_test=no", "var_type=optimized",
            "BoostBaseDir=#{Formula.factory('boost').prefix}/"]

    if snow_leopard_64?
      args << 'var_arch=x64'
    else
      args << 'var_arch=ia32'
    end

    system "scons", "install", *args
  end
end
