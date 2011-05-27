module Homebrew extend self
  def update
    abort "Please `brew install git' first." unless system "/usr/bin/which -s git"

    updater = RefreshBrew.new
    if updater.update_from_masterbrew!
      updater.report
    else
      puts "Already up-to-date."
    end
  end
end

class RefreshBrew
  REPOSITORY_URL   = "http://github.com/mxcl/homebrew.git"
  INIT_COMMAND     = "git init"
  CHECKOUT_COMMAND = "git checkout -q master"
  UPDATE_COMMAND   = "git pull #{REPOSITORY_URL} master"
  REVISION_COMMAND = "git log -l -1 --pretty=format:%H 2> /dev/null"
  GIT_UP_TO_DATE   = "Already up-to-date."

  formula_regexp   = 'Library/Formula/(.+?)\.rb'
  ADDED_FORMULA    = %r{^\s+create mode \d+ #{formula_regexp}$}
  UPDATED_FORMULA  = %r{^\s+#{formula_regexp}\s}
  DELETED_FORMULA  = %r{^\s+delete mode \d+ #{formula_regexp}$}

  example_regexp   = 'Library/Contributions/examples/([^.\s]+).*'
  ADDED_EXAMPLE    = %r{^\s+create mode \d+ #{example_regexp}$}
  UPDATED_EXAMPLE  = %r{^\s+#{example_regexp}}
  DELETED_EXAMPLE  = %r{^\s+delete mode \d+ #{example_regexp}$}

  attr_reader :added_formulae, :updated_formulae, :deleted_formulae, :installed_formulae
  attr_reader :added_examples, :updated_examples, :deleted_examples
  attr_reader :initial_revision

  def initialize
    @added_formulae, @updated_formulae, @deleted_formulae, @installed_formulae = [], [], [], []
    @added_examples, @updated_examples, @deleted_examples = [], [], []
    @initial_revision = self.current_revision
  end

  # Performs an update of the homebrew source. Returns +true+ if a newer
  # version was available, +false+ if already up-to-date.
  def update_from_masterbrew!
    output = ''
    HOMEBREW_REPOSITORY.cd do
      if File.directory? '.git'
        safe_system CHECKOUT_COMMAND
      else
        safe_system INIT_COMMAND
      end
      output = execute(UPDATE_COMMAND)
    end

    output.split("\n").reverse.each do |line|
      case line
      when ADDED_FORMULA
        @added_formulae << $1
      when DELETED_FORMULA
        @deleted_formulae << $1
      when UPDATED_FORMULA
        @updated_formulae << $1 unless @added_formulae.include?($1) or @deleted_formulae.include?($1)
      when ADDED_EXAMPLE
        @added_examples << $1
      when DELETED_EXAMPLE
        @deleted_examples << $1
      when UPDATED_EXAMPLE
        @updated_examples << $1 unless @added_examples.include?($1) or @deleted_examples.include?($1)
      end
    end
    @added_formulae.sort!
    @updated_formulae.sort!
    @deleted_formulae.sort!
    @added_examples.sort!
    @updated_examples.sort!
    @deleted_examples.sort!
    @installed_formulae = HOMEBREW_CELLAR.children.
      select{ |pn| pn.directory? }.
      map{ |pn| pn.basename.to_s }.sort

    output.strip != GIT_UP_TO_DATE
  end

  def pending_formulae_changes?
    !@updated_formulae.empty?
  end

  def pending_new_formulae?
    !@added_formulae.empty?
  end

  def deleted_formulae?
    !@deleted_formulae.empty?
  end

  def pending_examples_changes?
    !@updated_examples.empty?
  end

  def pending_new_examples?
    !@added_examples.empty?
  end

  def deleted_examples?
    !@deleted_examples.empty?
  end

  def current_revision
    HOMEBREW_REPOSITORY.cd { execute(REVISION_COMMAND).strip }
  rescue
    'TAIL'
  end

  def report
    puts "Updated Homebrew from #{initial_revision[0,8]} to #{current_revision[0,8]}."
    ## New Formulae
    if pending_new_formulae?
      ohai "The following formulae are new:"
      puts_columns added_formulae
    end
    ## Deleted Formulae
    if deleted_formulae?
      ohai "The following formulae were removed:"
      puts_columns deleted_formulae, installed_formulae
    end
    ## Updated Formulae
    if pending_formulae_changes?
      ohai "The following formulae were updated:"
      puts_columns updated_formulae, installed_formulae
    else
      puts "No formulae were updated."
    end
    ## New examples
    if pending_new_examples?
      ohai "The following external commands are new:"
      puts_columns added_examples
    end
    ## Deleted examples
    if deleted_examples?
      ohai "The following external commands were removed:"
      puts_columns deleted_examples
    end
    ## Updated Formulae
    if pending_examples_changes?
      ohai "The following external commands were updated:"
      puts_columns updated_examples
    else
      puts "No external commands were updated."
    end
  end

  private

  def execute(cmd)
    out = `#{cmd}`
    if $? && !$?.success?
      puts out
      raise "Failed while executing #{cmd}"
    end
    ohai(cmd, out) if ARGV.verbose?
    out
  end
end
