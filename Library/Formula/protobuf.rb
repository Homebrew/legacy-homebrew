require 'formula'

class Protobuf < Formula
  url 'http://protobuf.googlecode.com/files/protobuf-2.4.1.tar.bz2'
  homepage 'http://code.google.com/p/protobuf/'
  sha1 'df5867e37a4b51fb69f53a8baf5b994938691d6d'

  fails_with_llvm :build => 2334

  def options
    [['--universal', 'Do a universal build']]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make install"

    # Install editor support and documentation
    (share+'doc/protobuf').install %w( editors examples )

    # Install manpage protoc.1 from Debian package
    #  protobuf-compiler_2.4.1-1
    (man1+'protoc.1').write DATA.read
  end

  def caveats; <<-EOS.undent
      Editor support and examples have been installed to:
        #{HOMEBREW_PREFIX}/share/doc/protobuf
    EOS
  end
end


__END__
'\" t
.\"     Title: protoc
.\"    Author: Iustin Pop <iusty@k1024.org>
.\" Generator: DocBook XSL Stylesheets v1.76.1 <http://docbook.sf.net/>
.\"      Date: 2008-10-04
.\"    Manual: protocol buffer compiler
.\"    Source: protobuf 2.0.2
.\"  Language: English
.\"
.TH "PROTOC" "1" "2008\-10\-04" "protobuf 2\&.0\&.2" "protocol buffer compiler"
.\" -----------------------------------------------------------------
.\" * Define some portability stuff
.\" -----------------------------------------------------------------
.\" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.\" http://bugs.debian.org/507673
.\" http://lists.gnu.org/archive/html/groff/2009-02/msg00013.html
.\" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ie \n(.g .ds Aq \(aq
.el       .ds Aq '
.\" -----------------------------------------------------------------
.\" * set default formatting
.\" -----------------------------------------------------------------
.\" disable hyphenation
.nh
.\" disable justification (adjust text to left margin only)
.ad l
.\" -----------------------------------------------------------------
.\" * MAIN CONTENT STARTS HERE *
.\" -----------------------------------------------------------------
.SH "NAME"
protoc \- compile protocol buffer description files
.SH "SYNOPSIS"
.HP \w'\fBprotoc\fR\ 'u
\fBprotoc\fR [\fB\-\-cpp_out=\fR\fB\fIOUT_DIR\fR\fR] [\fB\-\-java_out=\fR\fB\fIOUT_DIR\fR\fR] [\fB\-\-python_out=\fR\fB\fIOUT_DIR\fR\fR] [\fB\-I\fR\fB\fIPATH\fR\fR\ |\ \fB\-\-proto\-path=\fR\fB\fIPATH\fR\fR] \fIPROTO_FILE\fR
.HP \w'\fBprotoc\fR\ 'u
\fBprotoc\fR {\fB\-h\fR | \fB\-\-help\fR}
.HP \w'\fBprotoc\fR\ 'u
\fBprotoc\fR \fB\-\-version\fR
.SH "DESCRIPTION"
.PP
\fBprotoc\fR
is a compiler for protocol buffers definitions files\&. It can can generate C++, Java and Python source code for the classes defined in
\fIPROTO_FILE\fR\&.
.SH "OPTIONS"
.PP
\fB\-I\fR\fB\fIPATH\fR\fR, \fB\-\-proto_path=\fR\fB\fIPATH\fR\fR
.RS 4
Specify the directory in which to search for imports\&. May be specified multiple times; directories will be searched in order\&. If not given, the current working directory is used\&.
.RE
.PP
\fB\-\-cpp_out=\fR\fB\fIOUT_DIR\fR\fR
.RS 4
Enable generation of C++ bindings and store them in
\fIOUT_DIR\fR\&.
.RE
.PP
\fB\-\-java_out=\fR\fB\fIOUT_DIR\fR\fR
.RS 4
Enable generation of Java bindings and store them in
\fIOUT_DIR\fR\&.
.RE
.PP
\fB\-\-python_out=\fR\fB\fIOUT_DIR\fR\fR
.RS 4
Enable generation of Python bindings and store them in
\fIOUT_DIR\fR\&.
.RE
.PP
\fB\-h\fR, \fB\-\-help\fR
.RS 4
Show summary of options\&.
.RE
.PP
\fB\-\-version\fR
.RS 4
Show version of program\&.
.RE
.PP
Note that at least one of the
\fB\-\-cpp_out\fR,
\fB\-\-java_out\fR
and
\fB\-\-python_out\fR
options must be given (otherwise the program has nothing to do)\&. It\*(Aqs also possible to specify more than one\&.
.SH "BUGS"
.PP
The program currently exits with code 255 for all errors, which makes it hard to differentiante from scripts the actual error\&.
.PP
The upstreams
BTS
can be found at
\m[blue]\fB\%http://code.google.com/p/protobuf/issues/list\fR\m[]\&.
.SH "SEE ALSO"
.PP
More documentation about protocol buffers syntax and APIs is available online at
\m[blue]\fB\%http://code.google.com/apis/protocolbuffers/docs/overview.html\fR\m[]\&.
.SH "AUTHOR"
.PP
\fBIustin Pop\fR <\&iusty@k1024\&.org\&>
.RS 4
Wrote this manpage for the Debian system\&.
.RE
.SH "COPYRIGHT"
.br
Copyright \(co 2007 Iustin Pop
.br
.PP
This manual page was written for the Debian system (but may be used by others)\&.
.PP
Permission is granted to copy, distribute and/or modify this document under the terms of the GNU General Public License, Version 2 or (at your option) any later version published by the Free Software Foundation\&.
.PP
On Debian systems, the complete text of the GNU General Public License can be found in
/usr/share/common\-licenses/GPL\&.
.sp
