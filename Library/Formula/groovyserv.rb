require 'formula'

class Groovyserv <Formula
  url 'http://github.com/downloads/kobo/groovyserv/groovyserv-0.5-macosx-bin.zip'
  version '0.5'
  md5 '6f569113bc4b7d0c9716ed73b2d1b5d5'
  head 'http://github.com/kobo/groovyserv.git', :using => :git
  homepage 'http://kobo.github.com/groovyserv/'

  # current Groovy on homebrew doesn't work well
  #depends_on 'groovy' unless ARGV.include? "--no-groovy"

  def install
    if ARGV.include? "--HEAD"
      install_from_head
    else
      install_from_zip
    end
  end

  def install_from_head
    system 'mvn package -Dmaven.test.skip=true'
    target_dir = Dir['target/groovyserv-*.dir/groovyserv-*/'][0]
    prefix.install %w{ LICENSE README }.map{ |f| "#{target_dir}/#{f}" }
    libexec.install %w{ bin lib }.map{ |f| "#{target_dir}/#{f}" }
    tweak_bin
  end

  def install_from_zip
    prefix.install %w{ LICENSE README }
    libexec.install %w{ bin lib }
    tweak_bin
  end

  def tweak_bin
    rm_f Dir["#{libexec}/bin/*.bat"]
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin + File.basename(f)
    end
  end
end
