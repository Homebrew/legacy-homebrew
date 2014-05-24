require 'formula'

class Electrum < Formula
  homepage 'https://electrum.org'
  url 'https://download.electrum.org/Electrum-1.9.8.tar.gz'
  sha256 '8fc144a32013e4a747fea27fff981762a6b9e14cde9ffb405c4c721975d846ff'

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on 'curl'    => :build
  depends_on 'gettext' => :build
  depends_on 'pyqt'

  resource 'ecdsa' do
    url 'https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz'
    sha256 '8e3b6c193f91dc94b2f3b0261e3eabbdc604f78ff99fdad324a56fdd0b5e958c'
  end

  resource 'pbkdf2' do
    url 'https://pypi.python.org/packages/source/p/pbkdf2/pbkdf2-1.3.tar.gz'
    sha256 'ac6397369f128212c43064a2b4878038dab78dab41875364554aaf2a684e6979'
  end

  resource 'pycurl' do
    url 'https://pypi.python.org/packages/source/p/pycurl/pycurl-7.19.3.1.tar.gz'
    sha256 'c0d673fe99a9de07239eabe77c798f1b043f60c02afaec1430ceaf59d7501a4f'
  end

  resource 'slowaes' do
    url 'https://pypi.python.org/packages/source/s/slowaes/slowaes-0.1a1.tar.gz'
    sha256 '83658ae54cc116b96f7fdb12fdd0efac3a4e8c7c7064e3fac3f4a881aa54bf09'
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    ENV.prepend_create_path 'PYTHONPATH', prefix+'lib/python2.7/site-packages'
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    res = %w[ecdsa pbkdf2 pycurl slowaes]
    res.each do |r|
      resource(r).stage { system "python", *install_args }
    end

    system "python", "mki18n.py"
    system "pyrcc4", "icons.qrc", "-o", "gui/qt/icons_rc.py"
    system "python", "setup.py", "build"
    system "python", "setup.py", "install", "--prefix=#{prefix}", "--optimize=1"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/electrum", "verifymessage", "1BwgQYh84KRX1anw6ptUyxGFUTQEtr2PxB", "G3I+Pimnb2YI7xN1oEAkD2PQCjG23wo//TVbgaAwPr4tbhTF8gUARGTVmfOqfEHGs5M785j4Kl3p7zyXFsBLa90=", "\"The Times 03/Jan/2009 Chancellor on brink of second bailout for banks\""
  end
end
