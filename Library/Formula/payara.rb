require 'formula'

class Payara < Formula
  desc "Java EE application server"
  homepage 'http://www.payara.co.uk/home'
  url 'https://s3-eu-west-1.amazonaws.com/payara.co/Payara+Downloads/payara-4.1.152.1.zip'
  sha1 'c7bdbe9c79b5206f1d4aeb51d2671512c4fd5df1'

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*", ".org.opensolaris,pkg"]
  end

  def caveats; <<-EOS.undent
    The home of Payara Application Server 4 is:
      #{opt_libexec}

    You may want to add the following to your .bash_profile:
      export PAYARA_HOME=#{opt_libexec}
      export PATH=${PATH}:${PAYARA_HOME}/bin

    Note: The support scripts used by Payara Application Server 4
    are *NOT* linked to bin.
  EOS
  end
end
