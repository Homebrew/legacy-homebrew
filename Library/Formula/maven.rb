require 'formula'

class Maven <Formula
  url 'http://www.apache.org/dist/maven/binaries/apache-maven-2.2.1-bin.tar.gz'
  head 'http://www.apache.org/dist/maven/binaries/apache-maven-3.0-beta-3-bin.tar.gz'
  homepage 'http://maven.apache.org/'

  if ARGV.build_head?
    md5 'b11cf59c8a4cd36741243267c58cf6a0'
  else
    md5 '3f829ed854cbacdaca8f809e4954c916'
  end

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
