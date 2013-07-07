require 'formula'

class ProofGeneral < Formula
  homepage 'http://proofgeneral.inf.ed.ac.uk'
  url 'http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.2.tgz'
  sha1 'c8d2e4457478b9dbf4080d3cf8255325fcffe619'

  option 'with-doc', 'Install documentations'
  option 'with-emacs=</path/to/emacs>', 'Re-compile the lisp files with a specified emacs'

  def which_emacs
    ARGV.each do |a|
      if a.index('--with-emacs')
        emacs = a.sub('--with-emacs=', '')
        raise "#{emacs} not found" if not File.exists? "#{emacs}"
        ohai "Use Emacs: #{emacs}"

        version = `#{emacs} --version | grep -Eo "GNU Emacs \\d+(\\.\\d+)+"`.gsub /\n/, ""
        ohai "Emacs version: #{version}"
        major = `echo "#{version}" | awk {'print $3'} | cut -d "." -f 1`.gsub /\n/, ""
        raise "Only Emacs of major version 23 is supported." if major != "23"
        return emacs
      end
    end
    return ""
  end

  def install
    emacs = which_emacs
    args = ["PREFIX=#{prefix}",
            "DEST_PREFIX=#{prefix}",
            "ELISPP=share/emacs/site-lisp/ProofGeneral",
            "ELISP_START=#{share}/emacs/site-lisp/site-start.d",
            "EMACS=#{emacs}"];

    Dir.chdir "ProofGeneral" do
      if emacs != ""
        system "make clean"
        system "make", "compile", *args
      end
      system "make", "install", *args
      man1.install "doc/proofgeneral.1"
      info.install "doc/ProofGeneral.info", "doc/PG-adapting.info"

      doc.install "doc/ProofGeneral", "doc/PG-adapting" if build.include? 'with-doc'
    end
  end

  def caveats
    doc = ""
    if build.include? 'with-doc'
      doc += <<-EOS.undent
         The HTML documentations are available in:
               #{HOMEBREW_PREFIX}/share/doc/proof-general
      EOS
    end

    <<-EOS.undent
    To use ProofGeneral with Emacs, add the following line to your ~/.emacs file:
      (load-file "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/ProofGeneral/generic/proof-site.el")
    #{doc}
    EOS
  end
end
