require 'formula'

class Jake <Formula
  head 'git://github.com/280north/jake.git'
  homepage 'http://github.com/280north/jake'

  depends_on 'narwhal'

  def install
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each { |d| ln_s d, bin }
  end
end
