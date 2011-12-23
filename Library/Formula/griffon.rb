require 'formula'

class Griffon < Formula
  url 'http://dist.codehaus.org/griffon/griffon/0.9.x/griffon-0.9.4-bin.tgz'
  homepage 'http://griffon.codehaus.org/'
  md5 'e3f7972462d47f30a2e7d3893b360489'

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

  def caveats
    <<-EOS.undent
      You should set the environment variable GRIFFON_HOME to
        #{libexec}
    EOS
  end
end
