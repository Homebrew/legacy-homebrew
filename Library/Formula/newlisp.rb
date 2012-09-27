require 'formula'

class Newlisp < Formula
  homepage 'http://www.newlisp.org/'
  url 'http://www.newlisp.org/downloads/newlisp-10.4.3.tgz'
  sha1 'cf5f5514a2a18dd317aa5e6f38907f0a8879156f'

  depends_on 'readline'

  def install
    # Required to use our configuration
    ENV.append_to_cflags "-DNEWCONFIG -c"

    system "./configure-alt", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    # Many .lsp files assume the interpreter will be installed in /usr/bin
    Dir["**/*.lsp"].each do |f|
      inreplace f do |s|
        s.gsub! '#!/usr/bin/newlisp', '#!/usr/bin/env newlisp'
        s.gsub! '/usr/bin/newlisp', "#{bin}/newlisp"
      end
    end

    system "make check"
    system "make install"
  end

  # Use the IDE to test a complete installation
  def test
    system "#{bin}/newlisp-edit"
  end
end
