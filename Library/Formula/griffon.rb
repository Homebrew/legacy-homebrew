require 'formula'

class Griffon < Formula
  url 'http://dist.codehaus.org/griffon/griffon/0.9.x/griffon-0.9.4-bin.zip'
  homepage 'http://griffon.codehaus.org/'
  md5 'e5048571e7a9ee5c7b1c3859d27c7e29'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[LICENSE README]
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      next unless File.extname(f).empty?
      ln_s f, bin+File.basename(f)
    end
  end

end
