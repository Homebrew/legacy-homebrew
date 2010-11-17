require 'formula'

class Maven2 <Formula
  url 'http://www.apache.org/dist/maven/binaries/apache-maven-2.2.1-bin.tar.gz'
  homepage 'http://maven.apache.org/'
  md5 '3f829ed854cbacdaca8f809e4954c916'

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

  def cavets; <<-EOS.undent
    WARNING: This older version will conflict with Maven if installed at the
    same time.
    EOS
  end
end
