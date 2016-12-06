require 'formula'

class Eli < Formula
  homepage 'http://fastarray.appspot.com'
  url 'http://fastarray.appspot.com/res/eli_mac.tar.gz'
  version '0.1a'
  sha1 '311cf3ca733fd5164a792c995f884dd0c7cd7459'

  def message; <<-EOS.undent
    Welcome to ELI!

    Code samples are in #{doc}/examples - enjoy!

    EOS
  end


  def install
    doc.mkpath
    doc.install 'eli_mac/eli_pt.jpg'
    doc.install Dir.glob('eli_mac/*.pdf')
    bin.install 'eli_mac/elim'
    mkpath "#{doc}/examples"
    cp Dir.glob('eli_mac/*.esf'), "#{doc}/examples"
    ohai message
  end

  test do
    `#{bin}/elim -v`.include? "Eli"
  end

end
