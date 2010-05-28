class RefreshBrew
  RESPOSITORY_URL  = 'git://github.com/mxcl/homebrew.git'
  INIT_COMMAND     = "git init"
  CHECKOUT_COMMAND = 'git checkout -q master'
  UPDATE_COMMAND   = "git pull #{RESPOSITORY_URL} master"
  REVISION_COMMAND = 'git log -l -1 --pretty=format:%H 2> /dev/null'
  GIT_UP_TO_DATE   = 'Already up-to-date.'
  
  formula_regexp   = 'Library/Formula/(.+?)\.rb'
  ADDED_FORMULA    = %r{^\s+create mode \d+ #{formula_regexp}$}
  UPDATED_FORMULA  = %r{^\s+#{formula_regexp}\s}
  
  attr_reader :added_formulae, :updated_formulae
  
  def initialize
    @added_formulae, @updated_formulae = [], []
  end
  
  # Performs an update of the homebrew source. Returns +true+ if a newer
  # version was available, +false+ if already up-to-date.
  def update_from_masterbrew!
    output = ''
    in_prefix do
      if File.directory? '.git'
        safe_system CHECKOUT_COMMAND
      else
        safe_system "git init"
      end
      output = execute(UPDATE_COMMAND)
    end

    output.split("\n").reverse.each do |line|
      case line
      when ADDED_FORMULA
        @added_formulae << $1
      when UPDATED_FORMULA
        @updated_formulae << $1 unless @added_formulae.include?($1)
      end
    end
    @added_formulae.sort!
    @updated_formulae.sort!
    
    output.strip != GIT_UP_TO_DATE
  end
  
  def pending_formulae_changes?
    !@updated_formulae.empty?
  end
  
  def current_revision
    in_prefix { execute(REVISION_COMMAND).strip }
  rescue
    'TAIL'
  end
  
  private
  
  def in_prefix
    Dir.chdir(HOMEBREW_REPOSITORY) { yield }
  end
  
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
