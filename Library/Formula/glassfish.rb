require 'formula'

class Glassfish < Formula
  url 'http://download.java.net/glassfish/3.1/release/glassfish-3.1.zip'
  homepage 'http://glassfish.org/'
  md5 'a4951c1a7268f92fd0bd6fada89f29d6'

  skip_clean :all

  def install
    rm_rf Dir['bin/*.bat']
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin
      chmod 0755, (bin + File.basename(f))
    end
    inreplace "#{libexec}/bin/asadmin" do |s|
      s.change_make_var! 'AS_INSTALL', "#{libexec}/glassfish"
    end
  end
end
