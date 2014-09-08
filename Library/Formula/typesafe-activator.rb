require 'formula'

class TypesafeActivator < Formula
  homepage 'http://typesafe.com/activator'
  url 'http://downloads.typesafe.com/typesafe-activator/1.2.10/typesafe-activator-1.2.10.zip'
  sha1 'b6cb5f46d4a491cbfbff1944b5147c9daa93ffe4'

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.write_exec_script libexec/'activator'
  end
end
