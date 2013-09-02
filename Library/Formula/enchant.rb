require 'formula'

class PyEnchant < Formula
  homepage 'http://pythonhosted.org/pyenchant/'
  url 'https://pypi.python.org/packages/source/p/pyenchant/pyenchant-1.6.5.tar.gz'
  sha1 '6f01b8657b64e970a11945c2a9b4d6d8023997bc'
end

class Enchant < Formula
  homepage 'http://www.abisource.com/projects/enchant/'
  url 'http://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz'
  sha1 '321f9cf0abfa1937401676ce60976d8779c39536'

  depends_on 'pkg-config' => :build
  depends_on :python => :recommended
  depends_on 'glib'
  depends_on 'aspell'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-ispell",
                          "--disable-myspell"
    system "make install"

    if build.with? 'python'
      # Now we handle the python bindings from the subformulae PyEnchant
      PyEnchant.new.brew do
        python do
          ENV['PYENCHANT_LIBRARY_PATH'] = lib/'libenchant.dylib'
          system python, 'setup.py', 'install', "--prefix=#{prefix}",
                                '--single-version-externally-managed',
                                '--record=installed.txt'
        end
      end
    end
  end

  def test
    if build.with? 'python'
      python do
        system python, "-c", "import enchant; d=enchant.Dict('en_US'); print(d.suggest('homebrew'))"
      end
    end
  end
end
