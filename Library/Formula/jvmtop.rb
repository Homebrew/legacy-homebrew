require 'formula'

class Jvmtop < Formula
  desc "Console application for monitoring all running JVMs on a machine"
  homepage 'https://code.google.com/p/jvmtop/'
  url 'https://jvmtop.googlecode.com/files/jvmtop-0.8.0.tar.gz'
  sha1 '36b8980fb2b34d83ea3e91438f71afc4482df66c'

  def install
    rm Dir['*.bat']
    mv 'jvmtop.sh', 'jvmtop'
    chmod 0755, 'jvmtop'

    libexec.install Dir['*']

    bin.write_exec_script libexec/'jvmtop'
  end
end
