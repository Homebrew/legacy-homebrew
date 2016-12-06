require 'formula'

class Gyp < Formula
  homepage 'http://code.google.com/p/gyp/'
  head 'http://gyp.googlecode.com/svn/trunk'

  depends_on 'scons'

  def install
    # This is very similar to the Duplicity formular.
    # Install mostly into libexec
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--install-purelib=#{libexec}",
                     "--install-platlib=#{libexec}",
                     "--install-scripts=#{bin}"

    # Shift files around to avoid needing a PYTHONPATH
    mv bin+'gyp', bin+'gyp.py'
    mv Dir[bin+'*'], libexec

    bin.install_symlink "#{libexec}/gyp.py" => "gyp"
  end
end
