require 'formula'

class TypesafeActivator < Formula
  homepage 'https://typesafe.com/activator'
  version '1.3.3'
  url 'https://downloads.typesafe.com/typesafe-activator/1.3.3/typesafe-activator-1.3.3-minimal.zip'
  sha1 '4930cd73b2d5b7e263287419c75df5be293b210a'

  bottle do
    cellar :any
    sha256 "e3666eb5dabe7c1e5214aeec713c35eaadf2220905a1a2a7f206751f03debe4d" => :yosemite
    sha256 "5809d11f274690d3342d84c8f28da0c0f330900a313acb70e544c5e21f6e90a0" => :mavericks
    sha256 "822e05462a7e1f500b93254686c11fba4d9dd36b9e015678fe21850153656c44" => :mountain_lion
  end

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir['*']
    chmod 0755, libexec/'activator'
    bin.write_exec_script libexec/'activator'
  end
end
