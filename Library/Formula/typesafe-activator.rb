require 'formula'

class TypesafeActivator < Formula
  homepage 'http://typesafe.com/activator'
  url 'http://downloads.typesafe.com/typesafe-activator/1.2.1/typesafe-activator-1.2.1.zip'
  sha1 '736e4a4349dc89994d11654aeca3b8ed32c4916b'

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.write_exec_script libexec/'activator'
  end
end
