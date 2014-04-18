require 'formula'
require 'ostruct'

class ProofGeneral < Formula
  homepage 'http://proofgeneral.inf.ed.ac.uk'
  url 'http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.2.tgz'
  sha1 'c8d2e4457478b9dbf4080d3cf8255325fcffe619'

  option 'with-doc', 'Install HTML documentation'
  option 'with-emacs=', 'Re-compile lisp files with specified emacs'

  def which_emacs
    emacs_binary = ARGV.value('with-emacs')
    if emacs_binary.nil?
      return OpenStruct.new(
        :binary => "",
        :major  => 0,
        :empty? => true)
    end

    raise "#{emacs_binary} not found" if not File.exist? "#{emacs_binary}"

    version_info = `#{emacs_binary} --version`
    version_info =~ /GNU Emacs (\d+)\./
    major = $1

    if major != '23' && major != '24'
      raise "Emacs 23.x or 24.x is required; #{major}.x provided."
    end

    return OpenStruct.new(
      :binary => emacs_binary,
      :major  => major,
      :empty? => false)
  end

  def install
    ENV.j1 # Otherwise lisp compilation can result in 0-byte files

    emacs = which_emacs
    args = ["PREFIX=#{prefix}",
            "DEST_PREFIX=#{prefix}",
            "ELISPP=share/emacs/site-lisp/ProofGeneral",
            "ELISP_START=#{share}/emacs/site-lisp/site-start.d",
            "EMACS=#{emacs.binary}"];

    Dir.chdir "ProofGeneral" do
      unless emacs.empty?
        # http://proofgeneral.inf.ed.ac.uk/trac/ticket/458
        if emacs.major == "24"
          inreplace 'Makefile', '(setq byte-compile-error-on-warn t)', ''
        end
        system "make clean"
        system "make", "compile", *args
      end
      system "make", "install", *args
      man1.install "doc/proofgeneral.1"
      info.install "doc/ProofGeneral.info", "doc/PG-adapting.info"

      doc.install "doc/ProofGeneral", "doc/PG-adapting" if build.with? "doc"
    end
  end

  def caveats
    doc = ""
    if build.with? "doc"
      doc += <<-EOS.undent
         HTML documentation is available in:
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
