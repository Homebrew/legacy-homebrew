class CommandboxBe < Formula
  desc "A CLI, package manager, app scaffolding tool with embedded CFML server"
  homepage "http://www.ortussolutions.com/products/commandbox"
  url "http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/3.1.0/commandbox-bin-3.1.0.zip"
  sha1 "2e3bab8443b7965931cd7c2f4edefc14c6e4297c"
  
  depends_on :arch => :x86_64
  depends_on :java => "1.7+"

  resource 'apidocs' do
    url "http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/3.1.0/commandbox-apidocs-3.1.0.zip"
    sha1 "5b20d54a3c24f16fb18cc93d88bd6df1fc317be2"
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