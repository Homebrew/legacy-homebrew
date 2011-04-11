require 'formula'

class Ant < Formula
  version '1.8.2'
  url 'http://apache.sunsite.ualberta.ca/ant/binaries/apache-ant-1.8.2-bin.tar.gz'
  md5 'afb0c7950a663f94e65da9f3be676d8f'
  homepage 'http://ant.apache.org'

  def install
    # Remove windows files
    rm_f Dir["bin/*.{bat,cmd,dll,exe}"]

    # Install jars in libexec to avoid conflicts
    prefix.install %w{ LICENSE NOTICE README WHATSNEW }
    libexec.install Dir['*']

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/ant"].each do |f|
      ln_s f, bin+File.basename(f)
    end
  end

  def test
    system "ant -version"
  end
end
