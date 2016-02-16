class Commandbox < Formula
  desc "A CLI, package manager, app scaffolding tool with embedded CFML server"
  homepage "http://www.ortussolutions.com/products/commandbox"
  url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.0.0/commandbox-bin-3.0.0.zip"
  sha1 "cb8d454b99d56c16e8501b4e1aa3c4eeb9b44451"
  
  depends_on :arch => :x86_64
  depends_on :java => "1.7+"

  resource 'apidocs' do
    url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.0.0/commandbox-apidocs-3.0.0.zip"
    sha1 "2ffe33c1d3ec02c56a9879c99ffe5b7fc792959a"
  end

  def install
    bin.install 'box'
    doc.install resource( "apidocs" )
  end

  test do
    box install
    box server start
  end

  def caveats
    "You will need at least Java JDK 1.7+ to run CommandBox"
  end

end