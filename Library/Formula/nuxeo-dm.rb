require 'formula'

class NuxeoDm <Formula
  url 'http://community.nuxeo.com/static/releases/nuxeo-5.4.0/nuxeo-dm-5.4.0_01-tomcat.zip'
  homepage 'http://community.nuxeo.com/'
  md5 '54363ca6ffdeae22879467b4914d2c70'
  version '5.4.0.1'

  depends_on 'imagemagick'
  depends_on 'pdftohtml'

  skip_clean :all

  def install
    nuxeo_dm = "nuxeo-dm-#{version}-tomcat"
    libexec.install Dir["#{nuxeo_dm}/*"]
    bin.mkpath
    ln_s libexec+"bin/nuxeoctl", bin+'nuxeoctl'
  end

  def caveats; <<-EOS.undent
    Nuxeo DM installed.

    To start Nuxeo DM:
      $ nuxeoctl start

    !!! USE IT ONLY FOR TESTING OR EXPERIMENTATION !!!

    Your data are not safe with this configuration, see the Nuxeo project
    homepage for production setup information:
      $ brew home nuxeo-dm

    EOS
  end

end
