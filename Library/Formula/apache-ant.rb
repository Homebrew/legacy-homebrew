require 'formula'

class ApacheAnt <Formula
  url 'http://mirror.mkhelif.fr/apache//ant/binaries/apache-ant-1.8.1-bin.zip'
  homepage 'http://ant.apache.org/index.html'
  md5 '671a3d4431df7e9ce29c08f7fcd7533d'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    prefix.install %w{ docs etc NOTICE LICENSE README }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin+File.basename(f)
    end
 end
end
