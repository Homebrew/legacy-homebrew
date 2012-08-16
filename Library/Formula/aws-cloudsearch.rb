require 'formula'

class AwsCloudsearch < Formula
  homepage 'http://aws.amazon.com/developertools/9054800585729911'
  url 'http://s3.amazonaws.com/amazon-cloudsearch-data/cloud-search-tools-1.0.0.1-2012.03.05.tar.gz'
  version '1.0.0.1-2012.03.05'
  sha1 'd0801bd19ba8f29e40e6bd04af53c8cf03758a0c'

  def install
    inreplace 'bin/cs-cmd', 'LIBDIR="${CS_HOME}/lib"', 'LIBDIR="${CS_HOME}/jars/lib"'
    (prefix+'jars').install 'lib'
    prefix.install %w{bin conf help third-party}
  end

  def caveats; <<-EOS.undent
    Add these to your shell profile:
      export JAVA_HOME="$(/usr/libexec/java_home)"
      export CS_HOME=#{prefix}
    EOS
  end
end
