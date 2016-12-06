require 'formula'

class BugsEverywhere <Formula
  head 'git://gitorious.org/be/be'
  homepage 'http://bugseverywhere.org/'

  depends_on 'PyYAML' => :python

  if ARGV.include? '--build-docs'
    depends_on 'sphinx' => :python
    depends_on 'numpydoc' => :python
  end

  def options
    [
      ['--build-docs', 'build and install Sphinx documentation']
    ]
  end

  def install
    # Generating this man page depends on `docbook-to-man`,
    # use pre-generated one.
    (Pathname.getwd+"doc/man/be.1").write man_1_be

    if ARGV.include? '--build-docs'
      system "make sphinx"
      doc.install "doc/.build/html" if ARGV.include? '--build-docs'
    else
      inreplace 'Makefile', 'doc: sphinx man', 'doc: man' unless ARGV.include? '--build-docs'
    end

    # The building assume it's in a Git repository.
    ENV['GIT_DIR']="#{@downloader.cached_location}/.git"

    system "make", "PREFIX=#{prefix}", "install"

    # Now we have lib/python2.[567]/site-packages/ with BE
    # libs in them. We want to move these out of site-packages into
    # a self-contained folder. Let's choose libexec.
    libexec.mkpath
    libexec.install Dir["#{lib}/python*/site-packages/*"]

    # Remove the useless egg-info file
    rm_f Dir["#{libexec}/*.egg-info"]

    # Move the BE startup script into libexec too, and link it from bin
    libexec.install bin+'be'
    ln_s libexec+'be', bin+'be'

    # Remove the hard-coded python invocation from be
    inreplace bin+'be', %r[#!/.*/python], '#!/usr/bin/env python'

    # We now have a self-contained BE install.
  end

  def man_1_be; <<'EOL'
.TH "BE" "1" 
.SH "NAME" 
be \(em distributed bug tracker 
.SH "SYNOPSIS" 
.PP 
\fBbe\fR [\fIcommand\fR]  [\fIcommand_options ...\fR]  [\fIcommand_args ...\fR]  
.PP 
\fBbe help\fR 
.PP 
\fBbe help\fR [\fIcommand\fR]  
.SH "DESCRIPTION" 
.PP 
This manual page documents briefly the 
\fBbe\fR command, part of the 
Bugs Everywhere package. 
.PP 
\fBbe\fR allows commandline interaction 
with the Bugs Everywhere database in a project tree. 
.SH "COMMANDS" 
.IP "\fBhelp\fR         " 10 
Print help for be and a list of all available commands. 
 
.SH "AUTHOR" 
.PP 
This manual page was written by Ben Finney <ben+debian@benfinney.id.au> for 
the \fBDebian\fP system (but may be used by others). Permission is 
granted to copy, distribute and/or modify this document under 
the terms of the GNU General Public License, Version 2 or any 
later version published by the Free Software Foundation. 
 
.PP 
On Debian systems, the complete text of the GNU General Public 
License can be found in /usr/share/common-licenses/GPL. 
 
.\" created by instant / docbook-to-man, Tue 05 Oct 2010, 22:37 
EOL
  end

  def test
    system "be --full-version"
  end
end
