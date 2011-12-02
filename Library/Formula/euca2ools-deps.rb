require 'formula'

class Euca2oolsDeps < Formula
  url 'http://open.eucalyptus.com/sites/all/modules/pubdlcnt/pubdlcnt.php?file=http://eucalyptussoftware.com/downloads/releases/euca2ools-1.3.1-src-deps.tar.gz&nid=1346'
  homepage 'http://open.eucalyptus.com/downloads'
  version '1.3.1'
  md5 'a33ee3a129fa9135d9896cc9fc5a621a'

  depends_on 'swig'

  def install
    File.open("README","w+") {|f| f.puts "Installs boto and M2Crypto libraries from euca2ools-deps, and nothing else"}
    install_boto
    install_m2crypto
  end

  def install_boto
    system <<-EOS
      tar zxvf boto-1.9b.tar.gz
      cd boto-1.9b
      python setup.py install
    EOS
  end

  def install_m2crypto
    system <<-EOS
      tar zxf M2Crypto-0.20.2.tar.gz
      cd M2Crypto-0.20.2
      python setup.py install
    EOS
  end
end
