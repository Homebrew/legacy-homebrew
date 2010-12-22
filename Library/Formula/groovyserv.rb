require 'formula'

class Groovyserv <Formula
  url 'https://github.com/downloads/kobo/groovyserv/groovyserv-0.5-src.zip'
  md5 'aecbf09143039305d4e8cc6a843800fb'
  head 'http://github.com/kobo/groovyserv.git', :using => :git
  homepage 'http://kobo.github.com/groovyserv/'

  def install
    system 'mvn package -Dmaven.test.skip=true'

    build_output_dir = Dir['target/groovyserv-*.dir/groovyserv-*/'][0]
    prefix.install "#{build_output_dir}/LICENSE"
    prefix.install "#{build_output_dir}/README"
    libexec.install "#{build_output_dir}/bin"
    libexec.install "#{build_output_dir}/lib"

    rm_f Dir["#{libexec}/bin/*.bat"]
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin + File.basename(f)
    end
  end
end
