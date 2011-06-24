require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.com/groovyserv/'
  url 'https://github.com/downloads/kobo/groovyserv/groovyserv-0.8_src.zip'
  sha1 '0b934c76d2bc71f0661dbcc36ef83dc33938051c'
  head 'http://github.com/kobo/groovyserv.git', :using => :git

  depends_on 'groovy'
  depends_on 'maven'

  def install
    # Build
    system 'mvn package -Dmaven.test.skip=true'

    # Install executables in libexec to avoid conflicts
    Dir::chdir Dir['target/groovyserv-*/groovyserv-*/'].first do
      libexec.install %w{bin lib}
    end
    prefix.install %w{LICENSE.txt README.txt NOTICE.txt}

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin + File.basename(f)
    end
  end
end
