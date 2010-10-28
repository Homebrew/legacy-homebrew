require 'formula'

class Hbase <Formula
  url 'http://apache.tradebit.com/pub/hbase/hbase-0.89.20100924/hbase-0.89.20100924-bin.tar.gz'
  homepage 'http://hbase.apache.org'
  md5 '6fdefc110c4d6414cc2b7e3697244e95'

  depends_on 'hadoop'

  def install
    def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec #{libexec}/bin/#{target} $*
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf docs lib hbase-webapps]
    libexec.install Dir['*.jar']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end
  end
end
