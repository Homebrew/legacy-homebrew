require 'formula'

class Felix < Formula
  homepage 'http://felix.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=/felix/org.apache.felix.main.distribution-4.2.1.tar.gz'
  sha1 '96322a8ccf802feb1151316b3367cac273f58823'

  def install
    libexec.install Dir['bin/*']
    prefix.install %w[conf bundle doc]
  end
end
