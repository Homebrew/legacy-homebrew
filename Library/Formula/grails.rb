require 'formula'

class Grails <Formula
  url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-1.3.6.zip'
  homepage 'http://grails.org'
  md5 '56fc68a118ca9c65e2c4391c3226a120'

  def install
    # we don't need these
    rm_f Dir["bin/*.bat"]

    # everything goes into libexec except the license and informational files
    prefix.install %w[LICENSE README INSTALL]
    libexec.install Dir["*"]

    # creates symbolic links for the grails binaries
    bin.mkpath
    grails_binaries.each do |f|
      next unless File.extname(f).empty?
      ln_s f, bin+File.basename(f)
    end
  end

  def grails_binaries
    Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Create a GRAILS_HOME environment variable that points to:
      #{libexec}
    EOS
  end
end