require "formula"

class Eric5 < Formula
  homepage "http://eric-ide.python-projects.org"
  url "https://downloads.sourceforge.net/project/eric-ide/eric5/stable/5.4.4/eric5-5.4.4.tar.gz"
  sha1 "89f942004ecb1b94bc750bf2e52798275464aad5"

  option "with-i18n-de", "Enable German language support"

  depends_on "python3"
  depends_on "qscintilla2" => "with-python3"
  depends_on "sip" => "with-python3"
  depends_on "pyqt" => "with-python3"
  depends_on "enchant" => :optional

  resource "i18n-de" do
    url 'https://downloads.sourceforge.net/project/eric-ide/eric5/stable/5.4.4/eric5-i18n-de-5.4.4.tar.gz'
    sha1 '6c037322549f49f1ec5a311063fabe4520485289'
  end

  def install
    system "python3", "install.py", "-n", "#{prefix}", "-b", "#{bin}",

    if build.with? 'i18n-de'
      resource('i18n-de').stage { system "python3", "install-i18n.py", "install", "--prefix=#{prefix}" }
    end
  end
end
