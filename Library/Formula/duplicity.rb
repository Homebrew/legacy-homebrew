require 'formula'

class Duplicity <Formula
  url 'http://code.launchpad.net/duplicity/0.6-series/0.6.06/+download/duplicity-0.6.06.tar.gz'
  homepage 'http://www.nongnu.org/duplicity/'
  md5 'abbbbcde4af24efffbc218583d581453'

  depends_on 'librsync'
  depends_on 'gnupg'

  def install
    ENV.universal_binary
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def caveats
    <<-EOS.undent
      If you are using a non-Homebrew-built Python, you may need to add:
        #{HOMEBREW_PREFIX}/lib/pythonX.Y/site-packages
      to your PYTHONPATH, where "X.Y" was the version of Python this
      formula was built against.
    EOS
  end
end
