require 'formula'

class Glassfish < Formula
  homepage 'http://glassfish.org/'
  url 'http://download.java.net/glassfish/3.1.2/release/glassfish-3.1.2.zip'
  sha1 '9e111bbd7791b63ae37220641867b47851a636d5'

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
