require "formula"

class Eric5 < Formula
  homepage "http://eric-ide.python-projects.org"
  url "https://downloads.sourceforge.net/project/eric-ide/eric5/stable/5.4.3/eric5-5.4.3.tar.gz"
  sha1 "4880ad4a36371c3aa0b46e588afc13beab3b1436"

  depends_on "python3"
  depends_on "qscintilla2" => "with-python3"
  depends_on "sip" => "with-python3"
  depends_on "pyqt" => "with-python3"
  depends_on "subversion" => [:optional, "with-python"]
  depends_on "enchant" => :optional
  option 'with-i18n-de' , "Enable German language support"

  if build.with? 'i18n-de'
    resource 'i18n-de' do
      url 'https://downloads.sourceforge.net/project/eric-ide/eric5/stable/5.4.3/eric5-i18n-de-5.4.3.tar.gz'
      sha1 'a09c1a9aae56f1128400f1ea3b4ca95970a0168d'
    end
  end

  def install

    system "python3", "install.py", "install", "--prefix=#{prefix}"

    if build.with? 'i18n-de'
      resource('i18n-de').stage { system "python3", "install-i18n.py", "install", "--prefix=#{prefix}" }
    end

  end

 test do
   system "#{bin}/eric5", "--version"
  end
end
