require 'formula'

class Whirr < Formula
  homepage 'http://whirr.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=whirr/whirr-0.8.0/whirr-0.8.0.tar.gz'
  sha1 '44056fee1fd0e83a7257772d1a20faeae8f5cd1d'

  def install
    libexec.install %w[bin conf lib]
    bin.write_exec_script libexec/'bin/whirr'
  end
end
