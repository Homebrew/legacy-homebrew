require 'formula'

class Glassfish < Formula
  homepage 'http://glassfish.org/'
  url 'http://download.java.net/glassfish/3.1.2.2/release/glassfish-3.1.2.2.zip'
  md5 'ae8e17e9dcc80117cb4b39284302763f'

  skip_clean :all

  def install
    rm_rf Dir['bin/*.bat']

    libexec.install Dir["*"]
    libexec.install Dir[".org.opensolaris,pkg"]
    bin.install_symlink Dir["#{libexec}/bin/*"]

    inreplace "#{libexec}/bin/asadmin" do |s|
      s.change_make_var! 'AS_INSTALL', "#{libexec}/glassfish"
    end
  end
end
