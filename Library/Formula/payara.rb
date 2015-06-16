class Payara < Formula
  desc "Java EE application server"
  homepage "http://www.payara.co.uk/home"
  url "https://s3-eu-west-1.amazonaws.com/payara.co/Payara+Downloads/payara-4.1.152.1.zip"
  sha256 "b57e5c816685b92c4ceecdaae6d1822a83fc6d2ee87765c9dcf68ae6c6d7e356"

  depends_on :java

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

  test do
    system "#{libexec}/bin/asadmin", "--help"
  end
end
