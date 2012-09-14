require 'formula'

class Whirr < Formula
  homepage 'http://whirr.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=whirr/whirr-0.8.0/whirr-0.8.0.tar.gz'
  sha1 '44056fee1fd0e83a7257772d1a20faeae8f5cd1d'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    libexec.install %w[bin conf lib]
    # Leave "examples" script in libexec
    (bin/'whirr').write shim_script('whirr')
  end
end
