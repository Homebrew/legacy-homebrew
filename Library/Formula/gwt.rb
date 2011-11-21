require 'formula'

class Gwt < Formula
  url 'http://google-web-toolkit.googlecode.com/files/gwt-2.4.0.zip'
  version '2.4.0'
  homepage 'http://google-web-toolkit.googlecode.com'
  md5 'f071dee835b402b36517e2c0a777ff34'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec #{prefix+name} $@
    EOS
  end

  def install
    prefix.install Dir["*"]
    bin.mkpath
    %w(webAppCreator benchmarkViewer i18nCreator).each do |tool|
      (bin+tool).write startup_script(tool)
    end
  end
end
