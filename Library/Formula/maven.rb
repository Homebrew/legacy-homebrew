require 'formula'

class Maven <Formula
  url 'http://www.apache.org/dist/maven/binaries/apache-maven-3.0.1-bin.tar.gz'
  homepage 'http://maven.apache.org/'
  md5 '98379efcef6b07bc44c27ec8382ad366'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    prefix.install %w{ NOTICE.txt LICENSE.txt README.txt }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin+File.basename(f)
    end
  end
end
