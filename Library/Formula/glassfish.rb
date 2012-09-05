require 'formula'

class Glassfish < Formula
  homepage 'http://glassfish.java.net/'
  url 'http://download.java.net/glassfish/3.1.2.2/release/glassfish-3.1.2.2.zip'
  sha1 '627e67d7e7f06583beb284c56f76456913461722'

  # To keep empty folders around
  skip_clean 'libexec'

  def install
    rm_rf Dir['bin/*.bat']

    libexec.install Dir["*"]
    libexec.install Dir[".org.opensolaris,pkg"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    inreplace "#{libexec}/bin/asadmin" do |s|
      s.change_make_var! 'AS_INSTALL', "#{libexec}/glassfish"
    end
  end
end
