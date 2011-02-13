require 'formula'

class Eclipse <Formula
  homepage 'www.eclipse.org'
  version '3.6.1'
  url 'http://download.eclipse.org/technology/epp/downloads/release/helios/SR1/eclipse-jee-helios-SR1-macosx-cocoa-x86_64.tar.gz'
  sha1 '5a12bc945d019500e2308adf6222cbbc600afed7'

  def install
    prefix.install %w[notice.html readme]
    libexec.install Dir['*']

    bin.mkpath
    ln_s libexec+'eclipse', bin
  end
end