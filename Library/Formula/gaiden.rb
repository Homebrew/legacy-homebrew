require 'formula'

class Gaiden < Formula
  homepage 'https://github.com/kobo/gaiden'
  url 'https://github.com/kobo/gaiden/releases/download/v0.3/gaiden-0.3.zip'
  sha1 '59f6998a9f58966339561cecca3abecaaec3f31c'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    The GAIDEN_HOME directory is:
      #{opt_prefix}/libexec
    EOS
  end
end

