class Commandbox < Formula
  desc "embedded server, package manager, and app scaffolding tools for CFML"
  homepage "http://www.ortussolutions.com/products/commandbox"
  url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.0.0/commandbox-bin-3.0.0.zip"
  sha1 "cb8d454b99d56c16e8501b4e1aa3c4eeb9b44451"
  
  depends_on :arch => :x86_64
  depends_on :java => "1.7+"

  resource 'apidocs' do
    url "http://downloads.ortussolutions.com/ortussolutions/commandbox/3.0.0/commandbox-apidocs-3.0.0.zip"
    sha1 "2ffe33c1d3ec02c56a9879c99ffe5b7fc792959a"
  end

  devel do
    url "http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/3.1.0/commandbox-bin-3.1.0.zip"
    sha1 "2e3bab8443b7965931cd7c2f4edefc14c6e4297c"
  end

  def install
    bin.install 'box'
    doc.install resource( "apidocs" )
  end

  test do
    system "box", "install"
    system "box", "--version"
  end

end
