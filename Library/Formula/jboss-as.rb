require 'formula'
#JBoss Application Server formula
#Download the binary distro from Sourceforge and unzip it
#The well-known name for this software is JBoss AS, hence jboss-as as a formula name
#
# @author Emmanuel Bernard emmanuel at hibernate.org
class JbossAs <Formula
  url 'http://downloads.sourceforge.net/project/jboss/JBoss/JBoss-6.0.0.CR1/jboss-as-distribution-6.0.0.20101110-CR1.zip'
  #the "official" version name whereas 6.0.0.20101110-CR1 is the OSGi compliant name
  version '6.0.0.CR1' 
  homepage 'https://jboss.org/jbossas'
  md5 '8599e8ec724c1877cdb752cc096e9572'

  #empty dirs are meaningful to JBoss AS => avoid cleaning
  skip_clean :all

  def install
    #remove MS Windows(TM) files
    rm_rf Dir['bin/*.{cmd,bat,exe]}']
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*.sh"].each { |f| ln_s f, bin }
  end

  def caveats; <<-EOS.undent
    The home of JBoss AS is
      #{libexec}
    deploy your applications under
      #{libexec}/server/[configuration]/deploy

    Note: Some of the support scripts used by JBoss AS have very generic names.
    These are likely to conflict with support scripts used by other Java-based
    server software.

    You may want to `brew unlink jboss-as` and add:
      #{bin}
    to your PATH instead.
    EOS
  end

  def patches
    # fix improper support for symlink sh scripts.
    # proposed as a patch to the JBoss AS team
    # https://jira.jboss.org/browse/JBAS-8670
    { :p1 => "https://gist.github.com/raw/719041/1a140235916262f680ccc700083bf0e0b21ae743/JBAS-8670-symlink.patch" }
  end
end
