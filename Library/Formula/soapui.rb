require 'formula'

class Soapui < Formula
  homepage 'http://www.soapui.org/'
  url 'http://sourceforge.net/projects/soapui/files/soapui/4.5.1/soapui-4.5.1-mac-bin.zip/download'
  version '4.5.1'
  sha1 'b2386e22259d9b8746e0f57fe03a61af16461f6d'

	def install
	    libexec.install Dir['*']
	    bin.install_symlink Dir["#{libexec}/bin/*.sh"]
	    system "chmod +x " "#{libexec}/bin/*.sh"	    
	end

	def test
	    system "#{bin}/soapui", "-e", "puts 'hello'"
  	end

  	def caveats;
    <<-EOS.undent
        Add the following into your $HOME/.bashrc or $HOME/.bash_profile or your shell's equivalent:

        ########################################################################################        
        # export SOAPUI_HOME                      => reflects location of SoapUI        
        ########################################################################################
        export SOAPUI_HOME=#{libexec}
    EOS
  end


end


