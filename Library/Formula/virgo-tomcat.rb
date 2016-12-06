require 'formula'

class VirgoStandard < Formula

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{name} $@
    EOS
  end

  def standard_install name
    # delete windowz stuff
    rm_f Dir["bin/*.{bat,vbs}"]

    # prefix.install %w{ About.html AboutKernel.html about_files docs epl-v10.html notice.html }
    libexec.install Dir['*']
    (libexec+'repository/usr').mkpath

    (bin+"virgo-#{name}-startup").write startup_script('startup.sh')
    (bin+"virgo-#{name}-startup").chmod 0755
    (bin+"virgo-#{name}-shutdown").write startup_script('shutdown.sh')
    (bin+"virgo-#{name}-shutdown").chmod 0755
  end

end

class VirgoTomcat < VirgoStandard

  homepage "http://www.eclipse.org/virgo/"
  # don't delete empty repository folders and work directory
  skip_clean :all
  version "3.0.0.M05"

  # have to add &dummy so file name is correct when downloaded
  url "http://www.eclipse.org/downloads/download.php?r=1&protocol=http&file=/virgo/milestone/VTS/#{version}/virgo-tomcat-server-#{version}.zip"
  md5 'da6342ca9996a2c873a8c1076bcb8132'

  def install
    standard_install 'tomcat'
  end
end
