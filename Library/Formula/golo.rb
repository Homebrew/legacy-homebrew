require 'formula'

class Golo < Formula
  homepage 'http://golo-lang.org'
  url 'http://sourceforge.net/projects/golo-lang/files/0-preview1/golo-0-preview1-distribution.tar.gz'
  sha1 'c5430039c4ec2d3ca8983589f23500efea71171e'
  version "0-preview1"

  def install
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install %w(bin doc lib samples)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<-EOS.undent
      You should set the environment variable GOLO_HOME to
        #{libexec}
    EOS
  end
end
