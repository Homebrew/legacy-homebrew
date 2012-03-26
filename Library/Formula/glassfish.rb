require 'formula'

class Glassfish < Formula
  homepage 'http://glassfish.org/'
  url 'http://download.java.net/glassfish/3.1.1/release/glassfish-3.1.1.zip'
  md5 'bf92c2c99b3d53b83bbc8c7e2124a897'

  skip_clean :all

  def install
    rm_rf Dir['bin/*.bat']

    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]

    inreplace "#{libexec}/bin/asadmin" do |s|
      s.change_make_var! 'AS_INSTALL', "#{libexec}/glassfish"
    end
  end
end
