require 'formula'

class Grails <Formula
  url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-1.3.7.zip'
  homepage 'http://grails.org'
  md5 'ea7cbfecdcf30c861f8faa8552ce3b46'

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    prefix.install %w[LICENSE README]
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      next unless File.extname(f).empty?
      ln_s f, bin+File.basename(f)
    end
  end
end
