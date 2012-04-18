require 'formula'

class AwsCloudsearch < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/developertools/9054800585729911'
  url 'http://s3.amazonaws.com/amazon-cloudsearch-data/cloud-search-tools-1.0.0.1-2012.03.05.tar.gz'
  version '1.0.0.1-2012.03.05'
  md5 'd5405f7c339afc81b317b8d434d168b3'

  def install
    inreplace 'bin/cs-cmd', 'LIBDIR="${CS_HOME}/lib"', 'LIBDIR="${CS_HOME}/jars/lib"'
    (prefix+'jars').install 'lib'
    prefix.install %w{bin conf help third-party}
  end

  def caveats;
    <<-EOS.undent
      To export the needed variables, add them to your dotfiles.
      * On Bash, add them to `~/.bash_profile`.
      * On Zsh, add them to `~/.zprofile` instead.

      export JAVA_HOME="$(/usr/libexec/java_home)"
      export CS_HOME=#{prefix}
      EOS
  end
end
