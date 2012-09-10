require 'formula'

class Glassfish < Formula
  homepage 'http://glassfish.org/'
  url 'http://download.java.net/glassfish/3.1.2.2/release/glassfish-3.1.2.2.zip'
  sha1 '627e67d7e7f06583beb284c56f76456913461722'

  skip_clean :all

  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    rm_rf Dir['bin/*.bat']

    libexec.install Dir["*"]
    libexec.install Dir[".org.opensolaris,pkg"]
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
      (bin+n).chmod 0755
    end

    inreplace "#{libexec}/bin/asadmin" do |s|
      s.change_make_var! 'AS_INSTALL', "#{libexec}/glassfish"
    end
  end
end
