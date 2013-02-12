require 'formula'
require 'IO'


class HomebrewBash < Requirement
  fatal true

  def initialize
    @bash_formula = Formula.factory 'bash'
    @bash_version = @bash_formula.version
    super
  end

  def message
    <<-EOS.undent
      This formula requires to be linked to an installation of Bash > 4.1.

      If you are happy with the version that homebrew provides (#{@bash_version}),
      you may do `brew install bash` and then brew this formula again.

      Else, you may pass the specific bash which you'd like bashdb to use
      using the `--with-bash=<path/to/bash>` option.

    EOS
  end

  satisfy do
    @bash_formula.installed?
  end
end

class CustomBash41 < Requirement
  fatal true

  def initialize(path_to_bash)
    @path_to_bash = path_to_bash
    @path_exists = File.exists? @path_to_bash
    @bash_version = self.check_version_for @path_to_bash
    super
  end

  def check_version_for(command)
    # Bash versioning scheme is "M.m.r(r)-tag"
    `#{command} --version 2>/dev/null` =~ /^GNU bash, version ([\d]+)\.([\d]+)\.([\w\-\(\)]+)\b/
    [$1, $2, $3]
  end

  def message
    if not @path_exists
      <<-EOS.undent
        The specified executable does not exist: #{@path_to_bash}.
      EOS
    else
      <<-EOS.undent
        The specified bash executable (version #{@bash_version.join '.'}) does not satisfy
        the requirements for bashdb (version >= 4.1).
      EOS
    end
  end

  satisfy do
    @path_exists and (@bash_version[0].to_i >= 4) and (@bash_version[1].to_i >= 1)
  end
end


class Bashdb < Formula
  homepage 'http://bashdb.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/bashdb/bashdb/4.2-0.8/bashdb-4.2-0.8.tar.bz2'
  sha1 'fc893fbe58416036815daa0e5e99f5fa409670ef'
  version '4.2-0.8'

  option 'with-bash=<path/to/bash>', 'Link to a specific bash executable'
  custom_bash = ARGV.find { |arg| /^--with-bash=(.*)/.match arg }

  if custom_bash
    bash_path = (custom_bash.split '=')[1]
    depends_on CustomBash41.new bash_path
    ENV['BASHDB_BASH_PATH'] = bash_path
  else
    depends_on HomebrewBash.new
    ENV['BASHDB_BASH_PATH'] = "#{HOMEBREW_PREFIX}/bin/bash"
  end

  def install
    bash_path = ENV['BASHDB_BASH_PATH']
    ohai "Using the Bash at #{bash_path}. See the options if you need another one."

    system "./configure", "--with-bash=#{bash_path}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end

  test do
    # This will show the classic testing header.
    system "bashdb", "--version"
    # To be sure, we'll also test if the output is what we expect.
    (`bashdb --version 2>/dev/null` =~ /^bashdb, release 4.2-0.8/) != nil
  end
end
