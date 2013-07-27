require 'formula'

class NinjaIde < Formula
  homepage 'http://ninja-ide.org/'
  url 'https://github.com/ninja-ide/ninja-ide/archive/v2.3.tar.gz'
  sha1 '64ccbbf8521a8fbef43c3d57cf616b7f8b466460'

  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on 'pyqt'

  def install
    python do
      system python, "setup.py", "install", "--prefix=#{prefix}"
    end

    if python
      system "pip install --upgrade macfsevents"
    end

    if python3
      system "pip3 install --upgrade macfsevents"
    end
  end

  def caveats
    <<-EOS.undent
      Run Ninja-IDE by typing `ninja-ide`
    EOS
  end

end
