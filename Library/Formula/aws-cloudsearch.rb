require 'formula'

class AwsCloudsearch < Formula
  homepage 'http://aws.amazon.com/developertools/9054800585729911'
  url 'https://s3.amazonaws.com/amazon-cloudsearch-data/cloud-search-tools-1.0.1.4-2013.01.11.tar.gz'
  version '1.0.1.4-2013.01.11'
  sha1 '8bd06d2b2660fb9bae2503b2540ca61036b1a169'

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
