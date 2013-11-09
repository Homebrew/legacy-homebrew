require 'formula'

class Pyyaml < Formula
  homepage 'http://pyyaml.org/wiki/PyYAML'
  url 'http://pyyaml.org/download/pyyaml/PyYAML-3.10.tar.gz'
  sha1 '476dcfbcc6f4ebf3c06186229e8e2bd7d7b20e73'

  depends_on :python
  depends_on 'libyaml'

  def install
    python do
      system python, "setup.py", "--with-libyaml", "install", "--prefix=#{prefix}"
    end
  end
end
