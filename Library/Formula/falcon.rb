# This formula currently uses the bundled libedit since there are known
# problems with readline.

require 'formula'

class FalconHtmldocs <Formula
  url 'http://falconpl.org/project_dl/_official_rel/Falcon-docs-core.0.9.6.4.tar.gz'
  md5 '94c5b17af5b9e06e4d97d497c292aad0'
end

class FalconFeathersHtmldocs <Formula
  url 'http://falconpl.org/project_dl/_official_rel/Falcon-feathers-docs.0.9.6.4.tar.gz'
  md5 '42ffa8650cf5a86e426837c38977ea5a'
end

class Falcon <Formula
  url 'http://falconpl.org/project_dl/_official_rel/Falcon-0.9.6.4.tar.gz'
  homepage 'http://www.falconpl.org/'
  md5 '35475a49f8dcc9ccf1c89f54de156951'

  depends_on 'cmake'
  depends_on 'pcre'

  def install
    cmake_opts = "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    ENV.append "EXTRA_CMAKE", cmake_opts
    system "./build.sh", "-p", "#{prefix}", "-int", "-el"
    system "./build.sh", "-i"
    # install the htmldocs for the core and standard modules (feathers)
    FalconHtmldocs.new.brew { (doc+'core-doc').install Dir['*'] }
    FalconFeathersHtmldocs.new.brew { (doc+'feathers-doc').install Dir['*'] }
  end

  def caveats; <<-EOS.undent
    HTML docs for the core and standard libraries (feathers) are
    installed in #{doc}/core-doc and
    #{doc}/feathers-doc respectively.
    EOS
  end
end
