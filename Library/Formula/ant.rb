require 'formula'

class Ant <Formula
  url 'http://www.apache.org/dist/ant/binaries/apache-ant-1.8.1-bin.tar.gz'
  homepage 'http://ant.apache.org/'
  md5 'dc9cc5ede14729f87fe0a4fe428b9185'

  def install
    rm Dir['bin/*.{bat,cmd}']
    libexec.install Dir['*']

    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin+File.basename(f)
    end
  end
end
