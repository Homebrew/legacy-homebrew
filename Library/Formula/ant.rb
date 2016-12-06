require 'formula'

class Ant <Formula
  url 'http://apache.ziply.com/ant/binaries/apache-ant-1.8.1-bin.tar.gz'
  homepage 'http://ant.apache.org/'
  md5 'dc9cc5ede14729f87fe0a4fe428b9185'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    prefix.install %w{ LICENSE NOTICE README WHATSNEW }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/ant"].each do |f|
      ln_s f, bin+File.basename(f)
    end
  end
end
